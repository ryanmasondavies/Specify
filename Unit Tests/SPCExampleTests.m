//
//  SPCExampleTests.m
//  Specify
//
//  Created by Ryan Davies on 30/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "SPCTestHelper.h"

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

- (void)testExecutesHooksBeforeExample
{
    id example = [OCMockObject partialMockForObject:[SPCExample new]];
    __block BOOL performedExecutedBeforeHooks = NO;
    [[[example stub] andDo:^(NSInvocation *invocation) { performedExecutedBeforeHooks = YES; }] executeBeforeHooks];
    [[[example stub] andDo:^(NSInvocation *invocation) { STAssertTrue(performedExecutedBeforeHooks, @""); }] execute];
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

- (void)testExecutesHooksAfterExample
{
    id example = [OCMockObject partialMockForObject:[SPCExample new]];
    __block BOOL performedExecute = NO;
    [[[example stub] andDo:^(NSInvocation *invocation) { performedExecute = YES; }] execute];
    [[[example stub] andDo:^(NSInvocation *invocation) { STAssertTrue(performedExecute, @""); }] executeAfterHooks];
}

#pragma mark Generating full names

- (void)testConcatenatesParentGroupNamesAndExampleName
{
    // Create groups:
    NSArray *groups = @[[OCMockObject niceMockForClass:[INLGroup class]], [OCMockObject niceMockForClass:[INLGroup class]]];
    [[[groups[0] stub] andReturn:@"a cat"] label];
    [[[groups[1] stub] andReturn:@"when it is fat"] label];
    [[[groups[1] stub] andReturn:groups[0]] parent];
    
    // Create an example:
    SPCExample *example = [[SPCExample alloc] init];
    [example setLabel:@"should be lazy"];
    [example setParent:groups[1]];
    
    STAssertEqualObjects([example fullName], @"a cat when it is fat should be lazy", @"Should have returned the concatenated names of the groups and example.");
}

- (void)testUsesJustExampleNameIfNotInGroup
{
    // Create and add an example to the spec:
    SPCExample *example = [[SPCExample alloc] init];
    [example setLabel:@"hello world"];
    STAssertEqualObjects([example fullName], @"hello world", @"Should have returned the name of the example.");
}

@end
