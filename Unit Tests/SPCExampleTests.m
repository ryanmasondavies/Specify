//
//  SPCExampleTests.m
//  Specify
//
//  Created by Ryan Davies on 30/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "SPCTestHelper.h"

typedef void(^InvocationBlock)(NSInvocation *invocation);

SPCGroup *(^groupWithHook)(SPCHook *hook) = ^(SPCHook *hook) {
    SPCGroup *group = [[SPCGroup alloc] init];
    [group addHook:hook];
    return group;
};

SPCHook *(^mockHook)(SPCExample *example, InvocationBlock onExecution) = ^(SPCExample *example, InvocationBlock onExecution) {
    id hook = [OCMockObject niceMockForClass:[SPCHook class]];
    [[[hook expect] andReturnValue:OCMOCK_VALUE((BOOL){YES})] isExecutableBeforeExample:example];
    [[[hook expect] andDo:onExecution] execute];
    [[[hook expect] andReturnValue:OCMOCK_VALUE((BOOL){YES})] isExecutableAfterExample:example];
    return hook;
};

SPCHook *(^mockBeforeEachHook)(SPCExample *example, InvocationBlock onExecution) = ^(SPCExample *example, InvocationBlock onExecution) {
    id hook = [OCMockObject niceMockForClass:[SPCHook class]];
    [[[hook expect] andReturnValue:OCMOCK_VALUE((BOOL){YES})] isExecutableBeforeExample:example];
    [[[hook expect] andDo:onExecution] execute];
    return hook;
};

SPCHook *(^mockAfterEachHook)(SPCExample *example, InvocationBlock onExecution) = ^(SPCExample *example, InvocationBlock onExecution) {
    id hook = [OCMockObject niceMockForClass:[SPCHook class]];
    [[[hook expect] andReturnValue:OCMOCK_VALUE((BOOL){YES})] isExecutableAfterExample:example];
    [[[hook expect] andDo:onExecution] execute];
    return hook;
};

@interface SPCExampleTests : SenTestCase
@end

@implementation SPCExampleTests

- (void)testInitialStateIsPending
{
    SPCExample *example = [[SPCExample alloc] init];
    STAssertTrue([example state] == SPCExampleStatePending, @"State should start as 'pending'.");
}

- (void)testSettingBlockChangesStateToReady
{
    SPCExample *example = [[SPCExample alloc] init];
    [example setBlock:^{}];
    STAssertTrue([example state] == SPCExampleStateReady, @"Example should become 'ready' when a block is assigned.");
}

#pragma mark Execution

- (void)testExecutesHooksBeforeExampleInForwardOrder
{
    // Create an example, an execution stack, a list of groups, and a base group:
    NSMutableArray *executed = [NSMutableArray array];
    SPCExample     *example  = [[SPCExample alloc] init];
    NSMutableArray *groups = [NSMutableArray arrayWithObject:[SPCGroup new]];
    
    // Nest 3 groups, each with a hook:
    NSMutableArray *hooks = [NSMutableArray array];
    for (NSUInteger i = 0; i < 3; i ++) {
        NSString *identifier = [NSString stringWithFormat:@"hook %d", i + 1];
        hooks[i] = mockBeforeEachHook(example, ^(NSInvocation *invocation) { [executed addObject:identifier]; });
        SPCGroup *group = groupWithHook(hooks[i]);
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
    __block BOOL executed = NO;
    SPCExample *example = [[SPCExample alloc] init];
    [example setBlock:^{ executed = YES; }];
    [example execute];
    STAssertTrue([example state] == SPCExampleStateExecuted, @"Should change state to 'executed'.");
    STAssertTrue(executed, @"Should invoke block when executed.");
}

- (void)testExecutesHooksAfterExampleInReverseOrder
{
    // Create an example, an execution stack, a list of groups, and a base group:
    NSMutableArray *executed = [NSMutableArray array];
    SPCExample     *example  = [[SPCExample alloc] init];
    NSMutableArray *groups = [NSMutableArray arrayWithObject:[SPCGroup new]];
    
    // Nest 3 groups, each with a hook:
    NSMutableArray *hooks = [NSMutableArray array];
    for (NSUInteger i = 0; i < 3; i ++) {
        NSString *identifier = [NSString stringWithFormat:@"hook %d", i + 1];
        hooks[i] = mockAfterEachHook(example, ^(NSInvocation *invocation) { [executed addObject:identifier]; });
        SPCGroup *group = groupWithHook(hooks[i]);
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
    SPCGroup *topGroup = [[SPCGroup alloc] init];
    NSArray *nestedGroups = @[[[SPCGroup alloc] init], [[SPCGroup alloc] init]];
    [topGroup addGroup:nestedGroups[0]];
    [topGroup addGroup:nestedGroups[1]];
    
    // Add an example to the first nested group:
    SPCExample *example = [[SPCExample alloc] init];
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
    SPCGroup *topGroup = [[SPCGroup alloc] init];
    SPCGroup *nestedGroup = [[SPCGroup alloc] init];
    [topGroup addGroup:nestedGroup];
    
    // Add an example to the top group:
    SPCExample *example = [[SPCExample alloc] init];
    [topGroup addExample:example];
    
    // Add a hook to the nested group:
    __block BOOL executed = NO;
    SPCBeforeEachHook *hook = [[SPCBeforeEachHook alloc] init];
    [hook setBlock:^{ executed = YES; }];
    [nestedGroup addHook:hook];
    
    // Execute the example:
    [example execute];
    
    // Ensure that the hook in the nested group was not executed:
    STAssertFalse(executed, @"Should not have executed the hook as it was in a deeper group than the example.");
}

#pragma mark Generating full names

- (void)testConcatenatesParentGroupNamesAndExampleName
{
    // Create groups:
    NSArray *groups = @[[OCMockObject niceMockForClass:[SPCGroup class]], [OCMockObject niceMockForClass:[SPCGroup class]]];
    [[[groups[0] stub] andReturn:@"a cat"] name];
    [[[groups[1] stub] andReturn:@"when it is fat"] name];
    [[[groups[1] stub] andReturn:groups[0]] parentGroup];
    
    // Create an example:
    SPCExample *example = [[SPCExample alloc] init];
    [example setName:@"should be lazy"];
    [example setParentGroup:groups[1]];
    
    // Test that the name is equal to the concatenated group names and example name:
    SPCTestSpecification *spec = [SPCTestSpecification testCaseWithInvocation:[INLTestInvocation invocationWithTest:example]];
    STAssertEqualObjects([spec name], @"a cat when it is fat should be lazy", @"Should have returned the concatenated names of the groups and example.");
}

- (void)testUsesJustExampleNameIfNotInGroup
{
    // Create and add an example to the spec:
    SPCExample *example = [[SPCExample alloc] init];
    [example setName:@"hello world"];
    
    // Test that the name is equal to the example name:
    SPCTestSpecification *spec = [SPCTestSpecification testCaseWithInvocation:[INLTestInvocation invocationWithTest:example]];
    STAssertEqualObjects([spec name], @"hello world", @"Should have returned the name of the example.");
}

@end
