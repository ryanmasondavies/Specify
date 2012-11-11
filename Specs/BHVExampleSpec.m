//
//  BHVExampleTests.m
//  Beehive
//
//  Created by Ryan Davies on 10/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVTestHelper.h"
#import "BHVSpec.h"
#import "BHVExample.h"

BOOL wasExecuted = NO;

SpecBegin(BHVExample)

it(@"should execute its block", ^{
    wasExecuted = YES;
});

SpecEnd

@interface CompilationTest : SenTestCase
@end

@implementation CompilationTest

- (void)testSingleExample
{
    wasExecuted = NO;
    RunSpec([BHVExampleSpec class]);
    STAssertTrue(wasExecuted, @"Did not run example.");
}

@end
