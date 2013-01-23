//
//  SPCBeforeEachHookTests.m
//  Specify
//
//  Created by Ryan Davies on 30/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "SPCTestHelper.h"

@interface SPCBeforeEachHookTests : SenTestCase
@end

@implementation SPCBeforeEachHookTests

- (void)testExecuteInvokesBlock
{
    SPCBeforeEachHook *hook = [SPCBeforeEachHook new];
    __block BOOL executed = NO;
    [hook setBlock:^{ executed = YES; }];
    [hook execute];
    STAssertTrue(executed, @"Should invoke block when executed.");
}

- (void)testIsExecutableBeforeExample
{
    STAssertTrue([[SPCBeforeEachHook new] isExecutableBeforeExample:[SPCExample new]], @"Should be executable before an example.");
}

- (void)testIsNotExecutableAfterExample
{
    STAssertFalse([[SPCBeforeEachHook new] isExecutableAfterExample:[SPCExample new]], @"Should not be executable after an example.");
}

@end
