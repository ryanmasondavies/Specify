//
//  BHVBeforeEachHookTests.m
//  Behave
//
//  Created by Ryan Davies on 30/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVTestHelper.h"

@interface BHVBeforeEachHookTests : SenTestCase
@end

@implementation BHVBeforeEachHookTests

- (void)testExecuteInvokesBlock
{
    BHVBeforeEachHook *hook = [BHVBeforeEachHook new];
    __block BOOL executed = NO;
    [hook setBlock:^{ executed = YES; }];
    [hook execute];
    STAssertTrue(executed, @"Should invoke block when executed.");
}

- (void)testIsExecutableBeforeExample
{
    STAssertTrue([[BHVBeforeEachHook new] isExecutableBeforeExample:[BHVExample new]], @"Should be executable before an example.");
}

- (void)testIsNotExecutableAfterExample
{
    STAssertFalse([[BHVBeforeEachHook new] isExecutableAfterExample:[BHVExample new]], @"Should not be executable after an example.");
}

@end
