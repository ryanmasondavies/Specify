//
//  BHVExampleTests.m
//  Behave
//
//  Created by Ryan Davies on 30/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "BHVExample.h"
#import "BHVContext.h"
#import "BHVHook.h"

@interface BHVExampleTests : SenTestCase
@end

@implementation BHVExampleTests

- (void)testMarksExampleAsExecuted
{
    BHVExample *example = [BHVExample new];
    [example execute];
    STAssertTrue([example isExecuted], @"Should have been marked as executed.");
}

- (void)testInvokesHooksInOrderRegardlessOfStructure
{
    // Create contexts, example, and hooks:
    NSArray *contexts = @[[BHVContext new], [BHVContext new]];
    BHVExample *example = [BHVExample new];
    NSArray *hooks = @[
        [[BHVHook alloc] initWithFlavor:BHVHookFlavorBeforeAll],
        [[BHVHook alloc] initWithFlavor:BHVHookFlavorBeforeEach],
        [[BHVHook alloc] initWithFlavor:BHVHookFlavorAfterEach],
        [[BHVHook alloc] initWithFlavor:BHVHookFlavorAfterAll]
    ];
    
    // Invocation of a hook adds a message to the list:
    NSMutableArray *messages = [NSMutableArray array];
    [hooks[0] setBlock:^{ [messages addObject:@"before all"]; }];
    [hooks[1] setBlock:^{ [messages addObject:@"before each"]; }];
    [hooks[2] setBlock:^{ [messages addObject:@"after each"]; }];
    [hooks[3] setBlock:^{ [messages addObject:@"after all"]; }];
    
    // Invoking the example adds a message to the list:
    [example setBlock:^{ [messages addObject:@"example"]; }];
    
    // In reverse order, add after/before all hooks to upper context, and after/before each to deeper context.
    [contexts[0] addHook:hooks[3]];
    [contexts[0] addHook:hooks[0]];
    [contexts[1] addHook:hooks[2]];
    [contexts[1] addHook:hooks[1]];
    
    // Add example to deeper context:
    [contexts[1] addExample:example];
    
    // Add deeper context to upper:
    [contexts[0] addContext:contexts[1]];
    
    // Execute example and check that the order is as follows:
    // - before all
    // - before each
    // - example
    // - after each
    // - after all
    
    [example execute];
    
    STAssertEqualObjects(messages[0], @"before all", @"Should have invoked `before all` hook first.");
    STAssertEqualObjects(messages[1], @"before each", @"Should have invoked `before each` hook second.");
    STAssertEqualObjects(messages[2], @"example", @"Should have invoked example third.");
    STAssertEqualObjects(messages[3], @"after each", @"Should have invoked `after each` hook fourth.");
    STAssertEqualObjects(messages[4], @"after all", @"Should have invoked `after all` hook fourth.");
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
    BHVHook *hook = [[BHVHook alloc] init];
    [hook setBlock:^{ executed = YES; }];
    [nestedContexts[1] addHook:hook];
    
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
    BHVHook *hook = [[BHVHook alloc] init];
    [hook setBlock:^{ executed = YES; }];
    [nestedContext addHook:hook];
    
    // Execute the example:
    [example execute];
    
    // Ensure that the hook in the nested context was not executed:
    STAssertFalse(executed, @"Should not have executed the hook as it was in a deeper context than the example.");
}

#pragma mark - Before All hooks

- (void)testInvokesBeforeAllHooksBeforeAllExamplesInHooksContext
{
    /* Creates the following structure:
     * 
     * hook 1
     * example 1
     * example 2
     * {
     *   hook 2
     *   example 3
     *   example 4
     * }
     *
     * Test executes all examples, then ensures that the following execution order was achieved:
     * - hook 1
     * - example 1
     * - example 2
     * - hook 2
     * - example 3
     * - example 4
     *
     * This validates that hooks are performed for all examples in the hook's context.
     */
    
    // Keep track of the invocation order:
    NSMutableArray *order = [NSMutableArray array];
    
    // Create four examples which add unique messages to the list:
    NSMutableArray *examples = [NSMutableArray array];
    for (NSUInteger i = 0; i < 4; i ++) {
        examples[i] = [[BHVExample alloc] init];
        [examples[i] setBlock:^{ [order addObject:[NSString stringWithFormat:@"example %d", i+1]]; }];
    }
    
    // Create two hooks which add unique messages to the list:
    NSMutableArray *hooks = [NSMutableArray array];
    for (NSUInteger i = 0; i < 2; i ++) {
        hooks[i] = [[BHVHook alloc] init];
        [hooks[i] setBlock:^{ [order addObject:[NSString stringWithFormat:@"hook %d", i+1]]; }];
    }
    
    // Create two contexts in which to store hooks and examples:
    NSMutableArray *contexts = [NSMutableArray array];
    for (NSUInteger i = 0; i < 2; i ++) {
        contexts[i] = [[BHVContext alloc] init];
    }
    
    // The second context nests within the first:
    [contexts[0] addContext:contexts[1]];
    
    // Hook 1, and examples 1 and 2 are nested within the topmost context:
    [contexts[0] addHook:hooks[0]];
    [contexts[0] addExample:examples[0]];
    [contexts[0] addExample:examples[1]];
    
    // Hook 2, and examples 3 and 4 are nested within the nested context:
    [contexts[1] addHook:hooks[1]];
    [contexts[1] addExample:examples[2]];
    [contexts[1] addExample:examples[3]];
    
    // Execute all examples:
    [examples makeObjectsPerformSelector:@selector(execute)];
    
    // Check the invocation order:
    STAssertEqualObjects(order[0], @"hook 1", @"Should have executed first beforeAll hook first.");
    STAssertEqualObjects(order[1], @"example 1", @"Should have executed first example second.");
    STAssertEqualObjects(order[2], @"example 2", @"Should have executed second example third.");
    STAssertEqualObjects(order[3], @"hook 2", @"Should have executed second beforeAll hook fourth.");
    STAssertEqualObjects(order[4], @"example 3", @"Should have executed third example fifth.");
    STAssertEqualObjects(order[5], @"example 4", @"Should have executed fourth example sixth.");
}

- (void)testInvokesBeforeAllHooksInForwardOrder
{
    /* Creates the following structure:
     * before all
     * {
     *   before all
     *   {
     *     example
     *   }
     * }
     */
    
    // Create two contexts, one within the other:
    NSArray *contexts = @[[[BHVContext alloc] init], [[BHVContext alloc] init]];
    [contexts[0] addContext:contexts[1]];
    
    // Add a hook at each level of the hierarchy, both of which add unique messages to the list:
    NSMutableArray *messages = [NSMutableArray array];
    NSMutableArray *hooks = [NSMutableArray array];
    for (NSUInteger i = 0; i < 2; i ++) {
        hooks[i] = [[BHVHook alloc] initWithFlavor:BHVHookFlavorBeforeAll];
        [hooks[i] setBlock:^{ [messages addObject:[NSString stringWithFormat:@"before all %d", i+1]]; }];
        [contexts[i] addHook:hooks[i]];
    }
    
    // Add an example that adds a unique message to the list to the deepest context:
    BHVExample *example = [[BHVExample alloc] init];
    [example setBlock:^{ [messages addObject:@"example"]; }];
    [contexts[1] addExample:example];
    
    // Execute the example:
    [example execute];
    
    // Ensure that the `before all` hooks were executed in shallowest-to-deepest order:
    STAssertTrue([messages count] == 3, @"Should have executed two `before all` hooks, then the example.");
    STAssertEqualObjects(messages[0], @"before all 1", @"Should have executed the outer before all hook first.");
    STAssertEqualObjects(messages[1], @"before all 2", @"Should have executed the inner before all hook second.");
    STAssertEqualObjects(messages[2], @"example", @"Should have executed the example last.");
}

#pragma mark - Before Each hooks

- (void)testInvokesBeforeEachHooksBeforeEachExample
{
    // Add hook to a context, and add a message to the list when invoked:
    NSMutableArray *messages = [NSMutableArray array];
    BHVContext *context = [[BHVContext alloc] init];
    BHVHook *hook = [[BHVHook alloc] initWithFlavor:BHVHookFlavorBeforeEach];
    [hook setBlock:^{ [messages addObject:@"before each"]; }];
    [context addHook:hook];
    
    // Add 3 examples to context, each of which adds a unique message to the list when invoked:
    NSMutableArray *examples = [NSMutableArray arrayWithCapacity:3];
    for (NSUInteger i = 0; i < 3; i ++) {
        examples[i] = [[BHVExample alloc] init];
        [examples[i] setBlock:^{ [messages addObject:[NSString stringWithFormat:@"example %d", i + 1]]; }];
        [context addExample:examples[i]];
    }
    
    // Execute each example:
    [examples makeObjectsPerformSelector:@selector(execute)];
    
    // Ensure that the hook was executed before each example:
    STAssertTrue([messages count] == 6, @"Should have executed the `before each` hook 3 times and 3 examples.");
    STAssertEqualObjects(messages[0], @"before each", @"Should have invoked `before each` hook before example 1.");
    STAssertEqualObjects(messages[1], @"example 1", @"Should have invoked example 1 first.");
    STAssertEqualObjects(messages[2], @"before each", @"Should have invoked `before each` hook before example 2.");
    STAssertEqualObjects(messages[3], @"example 2", @"Should have invoked example 2 second.");
    STAssertEqualObjects(messages[4], @"before each", @"Should have invoked `before each` hook before example 3.");
    STAssertEqualObjects(messages[5], @"example 3", @"Should have invoked example 3 third.");
}

#pragma mark - After Each hooks

- (void)testInvokesAfterEachHooksAfterEachExample
{
    // Add hook to a context, and add a message to the list when invoked:
    NSMutableArray *messages = [NSMutableArray array];
    BHVContext *context = [[BHVContext alloc] init];
    BHVHook *hook = [[BHVHook alloc] initWithFlavor:BHVHookFlavorAfterEach];
    [hook setBlock:^{ [messages addObject:@"after each"]; }];
    [context addHook:hook];
    
    // Add 3 examples to context, each of which adds a unique message to the list when invoked:
    NSMutableArray *examples = [NSMutableArray arrayWithCapacity:3];
    for (NSUInteger i = 0; i < 3; i ++) {
        examples[i] = [[BHVExample alloc] init];
        [examples[i] setBlock:^{ [messages addObject:[NSString stringWithFormat:@"example %d", i + 1]]; }];
        [context addExample:examples[i]];
    }
    
    // Execute each example:
    [examples makeObjectsPerformSelector:@selector(execute)];
    
    // Ensure that the hook was executed after each example:
    STAssertTrue([messages count] == 6, @"Should have executed the `after each` hook 3 times and 3 examples.");
    STAssertEqualObjects(messages[0], @"example 1", @"Should have invoked example 1 first.");
    STAssertEqualObjects(messages[1], @"after each", @"Should have invoked `after each` hook after example 1.");
    STAssertEqualObjects(messages[2], @"example 2", @"Should have invoked example 2 second.");
    STAssertEqualObjects(messages[3], @"after each", @"Should have invoked `after each` hook after example 2.");
    STAssertEqualObjects(messages[4], @"example 3", @"Should have invoked example 3 third.");
    STAssertEqualObjects(messages[5], @"after each", @"Should have invoked `after each` hook after example 3.");
}

#pragma mark - After All hooks

- (void)testInvokesAfterAllHooksOnce
{
    // Add hook to a context, and add a message to the list when invoked:
    NSMutableArray *messages = [NSMutableArray array];
    BHVContext *context = [[BHVContext alloc] init];
    BHVHook *hook = [[BHVHook alloc] initWithFlavor:BHVHookFlavorAfterAll];
    [hook setBlock:^{ [messages addObject:@"after all"]; }];
    [context addHook:hook];
    
    // Add 3 examples to context, each of which adds a unique message to the list when invoked:
    NSMutableArray *examples = [NSMutableArray arrayWithCapacity:3];
    for (NSUInteger i = 0; i < 3; i ++) {
        examples[i] = [[BHVExample alloc] init];
        [examples[i] setBlock:^{ [messages addObject:[NSString stringWithFormat:@"example %d", i + 1]]; }];
        [context addExample:examples[i]];
    }
    
    // Execute each example and ensure that the hook was executed first:
    [examples makeObjectsPerformSelector:@selector(execute)];
    
    // Ensure that the `after all` hook was executed last, after all 3 examples:
    STAssertTrue([messages count] == 4, @"Should have executed 3 examples, then the `after all` hook.");
    STAssertEqualObjects(messages[0], @"example 1", @"Should have invoked example 1 first.");
    STAssertEqualObjects(messages[1], @"example 2", @"Should have invoked example 2 second.");
    STAssertEqualObjects(messages[2], @"example 3", @"Should have invoked example 3 third.");
    STAssertEqualObjects(messages[3], @"after all", @"Should have invoked `after all` hook after all of the examples.");
}

@end
