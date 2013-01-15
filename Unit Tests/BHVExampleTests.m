//
//  BHVExampleTests.m
//  Behave
//
//  Created by Ryan Davies on 30/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVTestHelper.h"

typedef void(^InvocationBlock)(NSInvocation *invocation);

BHVContext *(^contextWithHook)(BHVHook *hook) = ^(BHVHook *hook) {
    BHVContext *context = [[BHVContext alloc] init];
    [context addHook:hook];
    return context;
};

BHVHook *(^mockHook)(BHVExample *example, InvocationBlock onExecution) = ^(BHVExample *example, InvocationBlock onExecution) {
    id hook = [OCMockObject niceMockForClass:[BHVHook class]];
    [[[hook expect] andReturnValue:OCMOCK_VALUE((BOOL){YES})] isExecutableBeforeExample:example];
    [[[hook expect] andDo:onExecution] execute];
    [[[hook expect] andReturnValue:OCMOCK_VALUE((BOOL){YES})] isExecutableAfterExample:example];
    return hook;
};

BHVHook *(^mockBeforeEachHook)(BHVExample *example, InvocationBlock onExecution) = ^(BHVExample *example, InvocationBlock onExecution) {
    id hook = [OCMockObject niceMockForClass:[BHVHook class]];
    [[[hook expect] andReturnValue:OCMOCK_VALUE((BOOL){YES})] isExecutableBeforeExample:example];
    [[[hook expect] andDo:onExecution] execute];
    return hook;
};

BHVHook *(^mockAfterEachHook)(BHVExample *example, InvocationBlock onExecution) = ^(BHVExample *example, InvocationBlock onExecution) {
    id hook = [OCMockObject niceMockForClass:[BHVHook class]];
    [[[hook expect] andReturnValue:OCMOCK_VALUE((BOOL){YES})] isExecutableAfterExample:example];
    [[[hook expect] andDo:onExecution] execute];
    return hook;
};

@interface BHVExampleTests : SenTestCase
@end

@implementation BHVExampleTests

- (void)testExecutesHooksBeforeExampleInForwardOrder
{
    // Create an example, an execution stack, a list of contexts, and a base context:
    NSMutableArray *executed = [NSMutableArray array];
    BHVExample     *example  = [[BHVExample alloc] init];
    NSMutableArray *contexts = [NSMutableArray arrayWithObject:[BHVContext new]];
    
    // Nest 3 contexts, each with a hook:
    NSMutableArray *hooks = [NSMutableArray array];
    for (NSUInteger i = 0; i < 3; i ++) {
        NSString *identifier = [NSString stringWithFormat:@"hook %d", i + 1];
        hooks[i] = mockBeforeEachHook(example, ^(NSInvocation *invocation) { [executed addObject:identifier]; });
        BHVContext *context = contextWithHook(hooks[i]);
        [contexts[i] addContext:context];
        [contexts addObject:context];
    }
    
    // Add example to deepest context:
    [[contexts lastObject] addExample:example];
    
    // The example should add an identifier to the execution list when executed:
    [example setBlock:^{ [executed addObject:@"example"]; }];
    
    // Execute the example:
    [example execute];
    
    // Verify the execution order:
    STAssertEqualObjects(executed[0], @"hook 1", @"");
    STAssertEqualObjects(executed[1], @"hook 2", @"");
    STAssertEqualObjects(executed[2], @"hook 3", @"");
    STAssertEqualObjects(executed[3], @"example", @"");
    
    // Verify hooks received messages:
    [hooks makeObjectsPerformSelector:@selector(verify)];
}

- (void)testInvokesBlockAndSetsStateToExecuted
{
#warning Pending example
}

- (void)testExecutesHooksAfterExampleInReverseOrder
{
    // Create an example, an execution stack, a list of contexts, and a base context:
    NSMutableArray *executed = [NSMutableArray array];
    BHVExample     *example  = [[BHVExample alloc] init];
    NSMutableArray *contexts = [NSMutableArray arrayWithObject:[BHVContext new]];
    
    // Nest 3 contexts, each with a hook:
    NSMutableArray *hooks = [NSMutableArray array];
    for (NSUInteger i = 0; i < 3; i ++) {
        NSString *identifier = [NSString stringWithFormat:@"hook %d", i + 1];
        hooks[i] = mockAfterEachHook(example, ^(NSInvocation *invocation) { [executed addObject:identifier]; });
        BHVContext *context = contextWithHook(hooks[i]);
        [contexts[i] addContext:context];
        [contexts addObject:context];
    }
    
    // Add example to deepest context:
    [[contexts lastObject] addExample:example];
    
    // The example should add an identifier to the execution list when executed:
    [example setBlock:^{ [executed addObject:@"example"]; }];
    
    // Execute the example:
    [example execute];
    
    // Verify the execution order:
    STAssertEqualObjects(executed[0], @"example", @"");
    STAssertEqualObjects(executed[1], @"hook 3", @"");
    STAssertEqualObjects(executed[2], @"hook 2", @"");
    STAssertEqualObjects(executed[3], @"hook 1", @"");
    
    // Verify hooks received messages:
    [hooks makeObjectsPerformSelector:@selector(verify)];
}

- (void)testIgnoresHooksNestedInSiblingContexts
{
    // Create context with two children:
    BHVContext *topContext = [[BHVContext alloc] init];
    NSArray *nestedContexts = @[[[BHVContext alloc] init], [[BHVContext alloc] init]];
    [topContext addContext:nestedContexts[0]];
    [topContext addContext:nestedContexts[1]];
    
    // Add an example to the first nested context:
    BHVExample *example = [[BHVExample alloc] init];
    [nestedContexts[0] addExample:example];
    
    // Add a hook to the second nested context:
    __block BOOL executed = NO;
    [nestedContexts[1] addHook:mockHook(example, ^(NSInvocation *i) { executed = YES; })];
    
    // Execute the example:
    [example execute];
    
    // Ensure that the hook in the second nested context was not executed:
    STAssertFalse(executed, @"Should not have executed the hook as it was in a sibling context to the context the example is nested in.");
}

- (void)testIgnoresHooksNestedInDeeperContexts
{
    // Create context with a nested context:
    BHVContext *topContext = [[BHVContext alloc] init];
    BHVContext *nestedContext = [[BHVContext alloc] init];
    [topContext addContext:nestedContext];
    
    // Add an example to the top context:
    BHVExample *example = [[BHVExample alloc] init];
    [topContext addExample:example];
    
    // Add a hook to the nested context:
    __block BOOL executed = NO;
    BHVBeforeEachHook *hook = [[BHVBeforeEachHook alloc] init];
    [hook setBlock:^{ executed = YES; }];
    [nestedContext addHook:hook];
    
    // Execute the example:
    [example execute];
    
    // Ensure that the hook in the nested context was not executed:
    STAssertFalse(executed, @"Should not have executed the hook as it was in a deeper context than the example.");
}

@end
