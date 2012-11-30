//
//  BHVBeforeFunctionTests.m
//  Beehive
//
//  Created by Ryan Davies on 29/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVBeforeFunction.h"
#import "BHVSpec.h"
#import "BHVSuite.h"
#import "BHVHook.h"
#import "BHVTestHelper.h"

@interface BHVBeforeFunctionTests : SenTestCase
@end

@implementation BHVBeforeFunctionTests

- (void)setUp
{
    [BHVSpec setCurrentSpec:[BHVTestSpec1 class]];
}

- (void)tearDown
{
    [BHVSpec resetSuites];
}

- (void)test_BeforeEach_AddsHookPositioned_Before_ToCurrentSpecSuite
{
    // Execute the `beforeEach` function:
    void(^block)(void) = ^{};
    beforeEach(block);
    
    // Check that a before-each hook has been added to the suite:
    BHVHook *hook = (BHVHook *)[[BHVTestSpec1 suite] nodeAtIndex:0];
    [[@([hook position]) should] beEqualTo:@(BHVHookPositionBefore)];
    [[[hook block] should] beEqualTo:block];
}

@end
