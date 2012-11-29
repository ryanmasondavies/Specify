//
//  BHVHookTests.m
//  Beehive
//
//  Created by Ryan Davies on 29/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVHook.h"

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

@end
