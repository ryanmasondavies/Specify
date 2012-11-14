//
//  BHVExpectationTests.m
//  Beehive
//
//  Created by Ryan Davies on 14/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVExpectation.h"
#import "BHVMatcher.h"
#import "BHVMatcherRegistry.h"

@interface BHVSuccessfulMatcher : BHVMatcher
- (BOOL)beAwesome;
@end

@implementation BHVSuccessfulMatcher

- (BOOL)beAwesome
{
    return YES;
}

@end

@interface BHVFailingMatcher : BHVMatcher
- (BOOL)beMediocre;
@end

@implementation BHVFailingMatcher

- (BOOL)beMediocre
{
    return NO;
}

@end

@interface BHVExpectationTests : SenTestCase
@end

@implementation BHVExpectationTests

- (void)testThrowsExceptionIfMatcherFails
{
    BHVExpectation *expectation = [[BHVExpectation alloc] init];
    [(id)expectation beMediocre];
    STAssertThrows([expectation verify], @"Expectation did not throw an exception but should have.");
}

- (void)testDoesNotThrowExceptionIfMatcherSucceeds
{
    BHVExpectation *expectation = [[BHVExpectation alloc] init];
    [(id)expectation beAwesome];
    STAssertNoThrow([expectation verify], @"Expectation did throw an exception but should not have.");
}

- (void)testThrowsExceptionIfNoMatcherImplementsSelector
{
    BHVExpectation *expectation = [[BHVExpectation alloc] init];
    STAssertThrows([expectation performSelector:@selector(someNonexistentSelector)], @"Expectation did not throw an exception but should have.");
}

@end
