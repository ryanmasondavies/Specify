//
//  BHVExampleTests.m
//  Behave
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

#pragma mark - Full name

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

#pragma mark - Execution

- (void)test_Execution_InvokesBlock
{
    __block BOOL invoked = NO;
    BHVExample *example = [[BHVExample alloc] init];
    [example setContext:[BHVContext new]];
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

- (void)test_Execution_WhenFirstExample_ExecutesHooksInTopContextBeforeBlock
{
    // Create a set of hooks:
    NSMutableArray *hooks = [NSMutableArray array];
    for (NSUInteger i = 0; i < 17; i ++) hooks[i] = [OCMockObject partialMockForObject:[BHVHook new]];
    
    // Branch the examples over a stack of contexts:
    BHVContext *context = BHVCreateBranchedStack(hooks);
    
    // Add an example to the top-level context:
    BHVExample *example = [[BHVExample alloc] init];
    [context addNode:example];
    
    // Set the example block to stop adding executions to the array when invoked:
    __block BOOL blockInvoked = NO;
    example.block = ^{ blockInvoked = YES; };
    
    // In order to track the execution order, stub out -execute to add the hook index to an array:
    NSMutableArray *order = [NSMutableArray array];
    [hooks enumerateObjectsUsingBlock:^(id hook, NSUInteger idx, BOOL *stop) {
        [[[hook stub] andDo:^(NSInvocation *invocation) {
            if (blockInvoked == NO) [order addObject:@(idx)];
        }] execute];
    }];
    
    // Execute the example:
    [example execute];
    
    // Verify that all hooks have the example set:
    [hooks enumerateObjectsUsingBlock:^(BHVHook *hook, NSUInteger idx, BOOL *stop) {
        [[[hook example] should] beIdenticalTo:example];
    }];
    
    // Verify that the hooks were executed from top to bottom:
    // TODO: Execute hooks until the context containing the example is hit.
    // TODO: Do not execute hooks in contexts that do not lead to the example.
    [[order should] beEqualTo:@[@0, @8, @16, @1, @4, @7, @9, @12, @15, @2, @3, @5, @6, @10, @11, @13, @14]];
}

- (void)test_Execution_WhenLastExample_ExecutesHooksBeforeBlockFromTopToBottom
{
    // Create a set of hooks:
    NSMutableArray *hooks = [NSMutableArray array];
    for (NSUInteger i = 0; i < 17; i ++) hooks[i] = [OCMockObject partialMockForObject:[BHVHook new]];
    
    // Branch the examples over a stack of contexts:
    BHVContext *context = BHVCreateBranchedStack(hooks);
    
    // Add an example to the last third-level context:
    BHVExample *example = [[BHVExample alloc] init];
    [[[context nodeAtIndex:3] nodeAtIndex:3] addNode:example];
    
    // Set the example block to stop adding executions to the array when invoked:
    __block BOOL blockInvoked = NO;
    example.block = ^{ blockInvoked = YES; };
    
    // In order to track the execution order, stub out -execute to add the hook index to an array:
    NSMutableArray *order = [NSMutableArray array];
    [hooks enumerateObjectsUsingBlock:^(id hook, NSUInteger idx, BOOL *stop) {
        [[[hook stub] andDo:^(NSInvocation *invocation) {
            if (blockInvoked == NO) [order addObject:@(idx)];
        }] execute];
    }];
    
    // Execute the example:
    [example execute];
    
    // Verify that all hooks have the example set:
    [hooks enumerateObjectsUsingBlock:^(BHVHook *hook, NSUInteger idx, BOOL *stop) {
        [[[hook example] should] beIdenticalTo:example];
    }];
    
    // Verify that the hooks were executed from top to bottom:
    [[order should] beEqualTo:@[@0, @8, @16, @1, @4, @7, @9, @12, @15, @2, @3, @5, @6, @10, @11, @13, @14]];
}

- (void)test_Execution_WhenFirstExample_ExecutesHooksInBottomContextAfterBlock
{
    // Create a set of hooks:
    NSMutableArray *hooks = [NSMutableArray array];
    for (NSUInteger i = 0; i < 17; i ++) hooks[i] = [OCMockObject partialMockForObject:[BHVHook new]];
    
    // Branch the examples over a stack of contexts:
    BHVContext *context = BHVCreateBranchedStack(hooks);
    
    // Add an example to the last third-level context:
    BHVExample *example = [[BHVExample alloc] init];
    [[[context nodeAtIndex:3] nodeAtIndex:3] addNode:example];
    
    // In order to track the execution order, stub out -execute to add the hook index to an array:
    NSMutableArray *order = [NSMutableArray array];
    [hooks enumerateObjectsUsingBlock:^(id hook, NSUInteger idx, BOOL *stop) {
        [[[hook stub] andDo:^(NSInvocation *invocation) { [order addObject:@(idx)]; }] execute];
    }];
    
    // Set the example block to remove all executions so far, leaving us with only the hooks that will be executed occur post-example-execution:
    example.block = ^{ [order removeAllObjects]; };
    
    // Execute the example:
    [example execute];
    
    // Verify that all hooks have the example set:
    [hooks enumerateObjectsUsingBlock:^(BHVHook *hook, NSUInteger idx, BOOL *stop) {
        [[[hook example] should] beIdenticalTo:example];
    }];
    
    // Verify that only the hooks were executed starting at the bottom:
    [[order should] beEqualTo:@[@13, @14, @9, @12, @15, @0, @8, @16]];
}

//- (void)test_Execution_ExecutesHooksAgainOnceBlockHasBeenInvokedInOutwardOrder
//{
//    // Create a set of hooks:
//    NSMutableArray *hooks = [NSMutableArray array];
//    for (NSUInteger i = 0; i < 17; i ++) hooks[i] = [OCMockObject partialMockForObject:[BHVHook new]];
//    
//    // Branch the examples over a stack of contexts:
//    BHVContext *context = BHVCreateBranchedStack(hooks);
//    
//    // In order to track the execution order, stub out -execute to add the hook index to an array:
//    NSMutableArray *order = [NSMutableArray array];
//    [hooks enumerateObjectsUsingBlock:^(id hook, NSUInteger idx, BOOL *stop) {
//        [[[hook stub] andDo:^(NSInvocation *invocation) { [order addObject:@(idx)]; }] execute];
//    }];
//    
//    // Add an example to the first third-level context:
//    BHVExample *example = [[BHVExample alloc] init];
//    [[[context nodeAtIndex:1] nodeAtIndex:1] addNode:example];
//    
//    // Set the example block to remove all executions so far, leaving us with only the hooks that will be executed occur post-example-execution:
//    example.block = ^{ [order removeAllObjects]; };
//    
//    // Execute the example:
//    [example execute];
//    
//    // Verify that all hooks have the example set:
//    [hooks enumerateObjectsUsingBlock:^(BHVHook *hook, NSUInteger idx, BOOL *stop) {
//        [[[hook example] should] beIdenticalTo:example];
//    }];
//    
//    // Verify that the hooks were executed starting at the deepest context and working outwards:
//    [[order should] beEqualTo:@[@2, @3, @5, @6, @10, @11, @13, @14, @1, @7, @9, @15, @0, @16]];
//}

@end
