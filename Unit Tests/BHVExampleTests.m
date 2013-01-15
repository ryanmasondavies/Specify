//
//  BHVExampleTests.m
//  Behave
//
//  Created by Ryan Davies on 30/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVTestHelper.h"

typedef void(^InvocationBlock)(NSInvocation *invocation);

BHVGroup *(^groupWithHook)(BHVHook *hook) = ^(BHVHook *hook) {
    BHVGroup *group = [[BHVGroup alloc] init];
    [group addHook:hook];
    return group;
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
    // Create an example, an execution stack, a list of groups, and a base group:
    NSMutableArray *executed = [NSMutableArray array];
    BHVExample     *example  = [[BHVExample alloc] init];
    NSMutableArray *groups = [NSMutableArray arrayWithObject:[BHVGroup new]];
    
    // Nest 3 groups, each with a hook:
    NSMutableArray *hooks = [NSMutableArray array];
    for (NSUInteger i = 0; i < 3; i ++) {
        NSString *identifier = [NSString stringWithFormat:@"hook %d", i + 1];
        hooks[i] = mockBeforeEachHook(example, ^(NSInvocation *invocation) { [executed addObject:identifier]; });
        BHVGroup *group = groupWithHook(hooks[i]);
        [groups[i] addGroup:group];
        [groups addObject:group];
    }
    
    // Add example to deepest group:
    [[groups lastObject] addExample:example];
    
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
    // Create an example, an execution stack, a list of groups, and a base group:
    NSMutableArray *executed = [NSMutableArray array];
    BHVExample     *example  = [[BHVExample alloc] init];
    NSMutableArray *groups = [NSMutableArray arrayWithObject:[BHVGroup new]];
    
    // Nest 3 groups, each with a hook:
    NSMutableArray *hooks = [NSMutableArray array];
    for (NSUInteger i = 0; i < 3; i ++) {
        NSString *identifier = [NSString stringWithFormat:@"hook %d", i + 1];
        hooks[i] = mockAfterEachHook(example, ^(NSInvocation *invocation) { [executed addObject:identifier]; });
        BHVGroup *group = groupWithHook(hooks[i]);
        [groups[i] addGroup:group];
        [groups addObject:group];
    }
    
    // Add example to deepest group:
    [[groups lastObject] addExample:example];
    
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

- (void)testIgnoresHooksNestedInSiblingGroups
{
    // Create group with two children:
    BHVGroup *topGroup = [[BHVGroup alloc] init];
    NSArray *nestedGroups = @[[[BHVGroup alloc] init], [[BHVGroup alloc] init]];
    [topGroup addGroup:nestedGroups[0]];
    [topGroup addGroup:nestedGroups[1]];
    
    // Add an example to the first nested group:
    BHVExample *example = [[BHVExample alloc] init];
    [nestedGroups[0] addExample:example];
    
    // Add a hook to the second nested group:
    __block BOOL executed = NO;
    [nestedGroups[1] addHook:mockHook(example, ^(NSInvocation *i) { executed = YES; })];
    
    // Execute the example:
    [example execute];
    
    // Ensure that the hook in the second nested group was not executed:
    STAssertFalse(executed, @"Should not have executed the hook as it was in a sibling group to the group the example is nested in.");
}

- (void)testIgnoresHooksNestedInDeeperGroups
{
    // Create group with a nested group:
    BHVGroup *topGroup = [[BHVGroup alloc] init];
    BHVGroup *nestedGroup = [[BHVGroup alloc] init];
    [topGroup addGroup:nestedGroup];
    
    // Add an example to the top group:
    BHVExample *example = [[BHVExample alloc] init];
    [topGroup addExample:example];
    
    // Add a hook to the nested group:
    __block BOOL executed = NO;
    BHVBeforeEachHook *hook = [[BHVBeforeEachHook alloc] init];
    [hook setBlock:^{ executed = YES; }];
    [nestedGroup addHook:hook];
    
    // Execute the example:
    [example execute];
    
    // Ensure that the hook in the nested group was not executed:
    STAssertFalse(executed, @"Should not have executed the hook as it was in a deeper group than the example.");
}

@end
