//
//  BHVHookTests.m
//  Beehive
//
//  Created by Ryan Davies on 29/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVHook.h"
#import "BHVContext.h"
#import "BHVExample.h"

@interface PSTBeMatcher ()
- (BOOL)beExecuted;
@end

@interface BHVHookTests : SenTestCase
@end

@implementation BHVHookTests

- (void)test_Execution_InvokesBlock
{
    __block BOOL invoked = NO;
    BHVHook *hook = [[BHVHook alloc] init];
    [hook setBlock:^{ invoked = YES; }];
    [hook execute];
    [[@(invoked) should] beTrue];
}

- (void)test_Execution_MarksAsExecuted
{
    BHVHook *hook = [[BHVHook alloc] init];
    [[hook shouldNot] beExecuted];
    [hook execute];
    [[hook should] beExecuted];
}

- (void)test_Before_Each_ExecutesIfExampleHasNotBeenExecuted
{
    BHVHook *hook = [[BHVHook alloc] init];
    [hook setPosition:BHVHookPositionBefore];
    [hook setFrequency:BHVHookFrequencyEach];
    
    BHVExample *example = [[BHVExample alloc] init];
    [hook setExample:example];
    
    [hook execute];
    
    [[hook should] beExecuted];
}

- (void)test_Before_Each_DoesNotExecuteIfExampleHasBeenExecuted
{
    BHVHook *hook = [[BHVHook alloc] init];
    [hook setPosition:BHVHookPositionBefore];
    [hook setFrequency:BHVHookFrequencyEach];
    
    BHVExample *example = [[BHVExample alloc] init];
    [example setExecuted:YES];
    [hook setExample:example];
    
    [hook execute];
    
    [[hook shouldNot] beExecuted];
}

- (void)test_After_Each_ExecutesIfExampleHasBeenExecuted
{
    BHVHook *hook = [[BHVHook alloc] init];
    [hook setPosition:BHVHookPositionAfter];
    [hook setFrequency:BHVHookFrequencyEach];
    
    BHVExample *example = [[BHVExample alloc] init];
    [example setExecuted:YES];
    [hook setExample:example];
    
    [hook execute];
    
    [[hook should] beExecuted];
}

- (void)test_After_Each_DoesNotExecuteIfExampleHasNotBeenExecuted
{
    BHVHook *hook = [[BHVHook alloc] init];
    [hook setPosition:BHVHookPositionAfter];
    [hook setFrequency:BHVHookFrequencyEach];
    
    BHVExample *example = [[BHVExample alloc] init];
    [hook setExample:example];
    
    [hook execute];
    
    [[hook shouldNot] beExecuted];
}

- (void)test_Before_All_ExecutesIfNoExamplesInExampleContextHaveBeenExecuted
{
    // Create hook:
    BHVHook *hook = [[BHVHook alloc] init];
    [hook setPosition:BHVHookPositionBefore];
    [hook setFrequency:BHVHookFrequencyAll];
    
    // Create context with a bunch of examples:
    BHVContext *context = [[BHVContext alloc] init];
    NSMutableArray *examples = [NSMutableArray array];
    for (NSUInteger i = 0; i < 10; i ++) {
        examples[i] = [[BHVExample alloc] init];
        [context addNode:examples[i]];
    }
    
    // Set example to any in the context and execute hook:
    [hook setExample:examples[4]];
    [hook execute];
    
    // Verify that the hook executed:
    [[hook should] beExecuted];
}

- (void)test_Before_All_DoesNotExecuteIfAnyExamplesInExampleContextHaveBeenExecuted
{
    // Create hook:
    BHVHook *hook = [[BHVHook alloc] init];
    [hook setPosition:BHVHookPositionBefore];
    [hook setFrequency:BHVHookFrequencyAll];
    
    // Create context with a bunch of examples:
    BHVContext *context = [[BHVContext alloc] init];
    NSMutableArray *examples = [NSMutableArray array];
    for (NSUInteger i = 0; i < 10; i ++) {
        examples[i] = [[BHVExample alloc] init];
        [context addNode:examples[i]];
    }
    
    // Mark any example as having been executed:
    [examples[7] setExecuted:YES];
    
    // Set example to any in the context and execute hook:
    [hook setExample:examples[4]];
    [hook execute];
    
    // Verify that the hook executed:
    [[hook shouldNot] beExecuted];
}

- (void)test_After_All_ExecutesIfAllExamplesInExampleContextHaveBeenExecuted
{
    // Create hook:
    BHVHook *hook = [[BHVHook alloc] init];
    [hook setPosition:BHVHookPositionAfter];
    [hook setFrequency:BHVHookFrequencyAll];
    
    // Create context with a bunch of examples:
    BHVContext *context = [[BHVContext alloc] init];
    NSMutableArray *examples = [NSMutableArray array];
    for (NSUInteger i = 0; i < 10; i ++) {
        examples[i] = [[BHVExample alloc] init];
        [examples[i] setExecuted:YES];
        [context addNode:examples[i]];
    }
    
    // Set example to any in the context and execute hook:
    [hook setExample:examples[4]];
    [hook execute];
    
    // Verify that the hook executed:
    [[hook should] beExecuted];
}

- (void)test_After_All_DoesNotExecuteIfAnyExampleInExampleContextHasNotBeenExecuted
{
    // Create hook:
    BHVHook *hook = [[BHVHook alloc] init];
    [hook setPosition:BHVHookPositionAfter];
    [hook setFrequency:BHVHookFrequencyAll];
    
    // Create context with a bunch of examples:
    BHVContext *context = [[BHVContext alloc] init];
    NSMutableArray *examples = [NSMutableArray array];
    for (NSUInteger i = 0; i < 10; i ++) {
        examples[i] = [[BHVExample alloc] init];
        [examples[i] setExecuted:YES];
        [context addNode:examples[i]];
    }
    
    // Mark any example as not executed:
    [examples[7] setExecuted:NO];
    
    // Set example to any in the context and execute hook:
    [hook setExample:examples[4]];
    [hook execute];
    
    // Verify that the hook executed:
    [[hook shouldNot] beExecuted];
}

@end
