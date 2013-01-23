//
//  SPCAfterEachHookTests.m
//  Specify
//
//  Created by Ryan Davies on 15/01/2013.
//  Copyright (c) 2013 Ryan Davies. All rights reserved.
//

#import "SPCTestHelper.h"

@interface SPCAfterEachHookTests : SenTestCase
@end

@implementation SPCAfterEachHookTests

- (void)testExecuteInvokesBlock
{
    SPCAfterEachHook *hook = [SPCAfterEachHook new];
    __block BOOL executed = NO;
    [hook setBlock:^{ executed = YES; }];
    [hook execute];
    STAssertTrue(executed, @"Should invoke block when executed.");
}

- (void)testIsNotExecutableBeforeExample
{
    STAssertFalse([[SPCAfterEachHook new] isExecutableBeforeExample:[SPCExample new]], @"Should not be executable before an example.");
}

- (void)testIsExecutableAfterExample
{
    STAssertTrue([[SPCAfterEachHook new] isExecutableAfterExample:[SPCExample new]], @"Should be executable after an example.");
}

@end
