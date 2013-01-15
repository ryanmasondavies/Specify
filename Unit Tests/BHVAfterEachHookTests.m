//
//  BHVAfterEachHookTests.m
//  Behave
//
//  Created by Ryan Davies on 15/01/2013.
//  Copyright (c) 2013 Ryan Davies. All rights reserved.
//

#import "BHVTestHelper.h"

@interface BHVAfterEachHookTests : SenTestCase
@end

@implementation BHVAfterEachHookTests

- (void)testExecuteInvokesBlock
{
    BHVAfterEachHook *hook = [BHVAfterEachHook new];
    __block BOOL executed = NO;
    [hook setBlock:^{ executed = YES; }];
    [hook execute];
    STAssertTrue(executed, @"Should invoke block when executed.");
}

- (void)testIsNotExecutableBeforeExample
{
    STAssertFalse([[BHVAfterEachHook new] isExecutableBeforeExample:[BHVExample new]], @"Should not be executable before an example.");
}

- (void)testIsExecutableAfterExample
{
    STAssertTrue([[BHVAfterEachHook new] isExecutableAfterExample:[BHVExample new]], @"Should be executable after an example.");
}

@end
