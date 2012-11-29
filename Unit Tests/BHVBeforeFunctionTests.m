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

- (void)test_BeforeEach_AddsHookToCurrentSpecSuiteWithNoDependency
{
    // Execute the `beforeEach` function:
    void(^block)(void) = ^{};
    beforeEach(block);
    
    // Check that an example has been added to the suite with the name and block:
    BHVHook *hook = (BHVHook *)[[BHVTestSpec1 suite] nodeAtIndex:0];
    [[[hook name] should] beEqualTo:@"before"];
    [[[hook block] should] beEqualTo:block];
}

@end
