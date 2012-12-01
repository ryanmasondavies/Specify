//
//  BHVExampleTests.m
//  Beehive
//
//  Created by Ryan Davies on 28/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVExample.h"
#import "BHVContext.h"
#import "BHVHook.h"

@interface PSTBeMatcher ()
- (BOOL)beExecuted;
@end

@interface BHVExampleTests : SenTestCase
@end

@implementation BHVExampleTests

- (void)setUp {}
- (void)tearDown {}

#pragma mark Full name

- (void)test_FullName_IncludesParentContextNames
{
    BHVExample *example = [[BHVExample alloc] init];
    [example setName:@"should do something"];
    
    BHVContext *nestedContext = [[BHVContext alloc] init];
    [nestedContext setName:@"in some state"];
    [nestedContext addNode:example];
    
    BHVContext *topContext = [[BHVContext alloc] init];
    [topContext setName:@"the thing"];
    [topContext addNode:nestedContext];
    
    [[[example fullName] should] beEqualTo:@"the thing in some state should do something"];
}

#pragma mark Execution

- (void)test_Execution_InvokesBlock
{
    __block BOOL invoked = NO;
    BHVExample *example = [[BHVExample alloc] init];
    [example setBlock:^{ invoked = YES; }];
    [example execute];
    [[@(invoked) should] beTrue];
}

- (void)test_Execution_MarksAsExecuted
{
    BHVExample *example = [[BHVExample alloc] init];
    [[example shouldNot] beExecuted];
    [example execute];
    [[example should] beExecuted];
}

- (void)test_Execution_ExecutesHooksPriorToInvokingBlockInForwardOrder
{
    // Create some contexts, each with a few hooks, and the deepest with one example:
    BHVContext *topMost = [[BHVContext alloc] init], *deepest;
    NSMutableArray *hooks = [NSMutableArray array];
    BHVContext *(^addContext)(BHVContext *parent) = ^(BHVContext *parent) {
        BHVContext *context = [[BHVContext alloc] init];
        BHVHook *hook = [OCMockObject partialMockForObject:[BHVHook new]];
        [context addNode:hook];
        [hooks addObject:hook];
        [parent addNode:context];
        return context;
    };
    for (NSUInteger i = 0; i < 10; i ++) deepest = addContext(topMost);
    
    // Add an example to the deepest context:
    BHVExample *example = [[BHVExample alloc] init];
    [deepest addNode:example];
    
    // In order to track the execution order, stub out -execute to add the hook index to an array:
    NSMutableArray *executionOrder = [NSMutableArray array];
    [hooks enumerateObjectsUsingBlock:^(id hook, NSUInteger idx, BOOL *stop) {
        [[[hook stub] andDo:^(NSInvocation *invocation) { [executionOrder addObject:@(idx)]; NSLog(@"Log execution of hook at index %d", idx); }] execute];
    }];
    
    // Set the example block to stop adding executions to the array when invoked:
    example.block = ^{
        [hooks enumerateObjectsUsingBlock:^(id hook, NSUInteger idx, BOOL *stop) {
            [hook stop];
        }];
    };
    
    // Execute the example:
    [example execute];
    
    // Verify that all hooks have the example set:
    [hooks enumerateObjectsUsingBlock:^(BHVHook *hook, NSUInteger idx, BOOL *stop) {
        [[[hook example] should] beIdenticalTo:example];
    }];
    
    // Verify that the hooks were executed in order:
    [executionOrder enumerateObjectsUsingBlock:^(NSNumber *index, NSUInteger i, BOOL *stop) {
        [[index should] beEqualTo:@(i)];
    }];
}

- (void)test_Execution_ExecutesHooksAgainOnceBlockHasBeenInvoked
{
    // Create some contexts, each with a few hooks, and the deepest with one example:
    BHVContext *topMost = [[BHVContext alloc] init], *deepest;
    NSMutableArray *hooks = [NSMutableArray array];
    BHVContext *(^addContext)(BHVContext *parent) = ^(BHVContext *parent) {
        BHVContext *context = [[BHVContext alloc] init];
        BHVHook *hook = [OCMockObject partialMockForObject:[BHVHook new]];
        [context addNode:hook];
        [hooks addObject:hook];
        [parent addNode:context];
        return context;
    };
    for (NSUInteger i = 0; i < 10; i ++) deepest = addContext(topMost);
    
    // Add an example to the deepest context:
    BHVExample *example = [[BHVExample alloc] init];
    [deepest addNode:example];
    
    // In order to track the execution order, stub out -execute to add the hook index to an array:
    NSMutableArray *executionOrder = [NSMutableArray array];
    [hooks enumerateObjectsUsingBlock:^(id hook, NSUInteger idx, BOOL *stop) {
        [[[hook stub] andDo:^(NSInvocation *invocation) { [executionOrder addObject:@(idx)]; }] execute];
    }];
    
    // Set the example block to remove all executions so far, leaving us with only the hooks that will be executed occur post-example-execution:
    example.block = ^{ [executionOrder removeAllObjects]; };
    
    // Execute the example:
    [example execute];
    
    // Verify that all hooks have the example set:
    [hooks enumerateObjectsUsingBlock:^(BHVHook *hook, NSUInteger idx, BOOL *stop) {
        [[[hook example] should] beIdenticalTo:example];
    }];
    
    // Verify that the hooks were executed in reverse order:
    [executionOrder enumerateObjectsUsingBlock:^(NSNumber *index, NSUInteger i, BOOL *stop) {
        [[index should] beEqualTo:@(9 - i)];
    }];
}

@end
