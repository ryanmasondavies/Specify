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

@interface BHVTestHook : BHVHook
@end

@implementation BHVTestHook

- (void)execute
{
    self.executed = YES;
}

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

- (void)test_Execution_ExecutesHooksPriorToInvokingBlock
{
    // Create some contexts, each with a few hooks, and the deepest with one example:
    NSMutableArray *contexts = [NSMutableArray array];
    NSMutableArray *hooks = [NSMutableArray array];
    BHVExample *example = [[BHVExample alloc] init];
    for (NSUInteger i = 0; i < 10; i ++) {
        // Create a context:
        contexts[i] = [[BHVContext alloc] init];
        
        // Add a hook:
        hooks[i] = [[BHVTestHook alloc] init];
        [contexts[i] addNode:hooks[i]];
        
        // Add the context to the previous context:
        if (i > 0) [contexts[i] addNode:contexts[i - 1]];
        
        // If at the deepest context, add the example:
        if (i == 9) [contexts[i] addNode:example];
    }
    
    // The example block sets 'executed before block' for each hook, if it has been executed:
    NSMutableArray *executedBeforeBlock = [NSMutableArray array];
    void(^block)(void) = ^{
        [hooks enumerateObjectsUsingBlock:^(BHVHook *hook, NSUInteger idx, BOOL *stop) {
            executedBeforeBlock[idx] = @([hook isExecuted]);
        }];
    };
    [example setBlock:block];
    
    // Execute the example:
    [example execute];
    
    // Verify that all hooks were executed before the block:
    [executedBeforeBlock enumerateObjectsUsingBlock:^(NSNumber *executed, NSUInteger idx, BOOL *stop) {
        [[executed should] beTrue];
    }];
}

- (void)test_Execution_ExecutesHooksAgainOnceBlockHasBeenInvoked
{
    // Create some contexts, each with a few hooks, and the deepest with one example:
    NSMutableArray *contexts = [NSMutableArray array];
    NSMutableArray *hooks = [NSMutableArray array];
    BHVExample *example = [[BHVExample alloc] init];
    for (NSUInteger i = 0; i < 10; i ++) {
        // Create a context:
        contexts[i] = [[BHVContext alloc] init];
        
        // Add a hook:
        hooks[i] = [[BHVTestHook alloc] init];
        [contexts[i] addNode:hooks[i]];
        
        // Add the context to the previous context:
        if (i > 0) [contexts[i] addNode:contexts[i - 1]];
        
        // If at the deepest context, add the example:
        if (i == 9) [contexts[i] addNode:example];
    }
    
    // The example block resets the hooks `executed` status:
    void(^block)(void) = ^{
        [hooks enumerateObjectsUsingBlock:^(BHVHook *hook, NSUInteger idx, BOOL *stop) {
            [hook setExecuted:NO];
        }];
    };
    [example setBlock:block];
    
    // Execute the example:
    [example execute];
    
    // Verify that all hooks were executed, even after they were reset in the block:
    [hooks enumerateObjectsUsingBlock:^(BHVHook *hook, NSUInteger idx, BOOL *stop) {
        [[hook should] beExecuted];
    }];
}

@end
