//
//  BHVSpecTests.m
//  Beehive
//
//  Created by Ryan Davies on 11/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "BHVTestHelper.h"
#import "BHVSpec.h"
#import "BHVExample.h"

BOOL executed = NO;

SpecBegin(BHVSample)

it(@"should mark executed as true", ^{
    executed = YES;
});

SpecEnd

@interface BHVSpecTests : SenTestCase; @end

@implementation BHVSpecTests

- (void)setUp
{
    executed = NO;
}

- (void)testRunsExamples
{
    RunSpecClass([BHVSampleSpec class]);
    STAssertTrue(executed, @"Was not executed");
}

@end
