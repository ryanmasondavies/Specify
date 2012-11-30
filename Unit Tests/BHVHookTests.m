//
//  BHVHookTests.m
//  Beehive
//
//  Created by Ryan Davies on 29/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVHook.h"
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

- (void)test_Before_ExecutesIfExampleHasNotExecuted
{
    BHVHook *hook = [[BHVHook alloc] init];
    [hook setPosition:BHVHookPositionBefore];
    
    BHVExample *example = [[BHVExample alloc] init];
    [hook setExample:example];
    
    [hook execute];
    
    [[hook should] beExecuted];
}

- (void)test_Before_DoesNotExecuteIfExampleHasExecuted
{
    BHVHook *hook = [[BHVHook alloc] init];
    [hook setPosition:BHVHookPositionBefore];
    
    BHVExample *example = [[BHVExample alloc] init];
    [example setExecuted:YES];
    [hook setExample:example];
    
    [hook execute];
    
    [[hook shouldNot] beExecuted];
}

- (void)test_After_ExecutesIfExampleHasExecuted
{
    BHVHook *hook = [[BHVHook alloc] init];
    [hook setPosition:BHVHookPositionAfter];
    
    BHVExample *example = [[BHVExample alloc] init];
    [example setExecuted:YES];
    [hook setExample:example];
    
    [hook execute];
    
    [[hook should] beExecuted];
}

- (void)test_After_DoesNotExecuteIfExampleHasNotBeenExecuted
{
    BHVHook *hook = [[BHVHook alloc] init];
    [hook setPosition:BHVHookPositionAfter];
    
    BHVExample *example = [[BHVExample alloc] init];
    [hook setExample:example];
    
    [hook execute];
    
    [[hook shouldNot] beExecuted];
}

@end
