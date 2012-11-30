//
//  BHVAfterEachTests.m
//  Beehive
//
//  Created by Ryan Davies on 30/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVAfterEach.h"
#import "BHVSpec.h"
#import "BHVSuite.h"
#import "BHVHook.h"
#import "BHVTestHelper.h"

@interface BHVAfterEachTests : SenTestCase
@end

@implementation BHVAfterEachTests

- (void)setUp
{
    [BHVSpec setCurrentSpec:[BHVTestSpec1 class]];
}

- (void)tearDown
{
    [BHVSpec resetSuites];
}

- (void)testAddsHookPositioned_After_ToCurrentSpecSuite
{
    // Execute the `afterEach` function:
    void(^block)(void) = ^{};
    afterEach(block);
    
    // Check that a hook positioned 'after' has been added to the suite:
    BHVHook *hook = (BHVHook *)[[BHVTestSpec1 suite] nodeAtIndex:0];
    [[@([hook position]) should] beEqualTo:@(BHVHookPositionAfter)];
    [[[hook block] should] beEqualTo:block];
}

@end
