//
//  BHVEqualityTests.m
//  Beehive
//
//  Created by Ryan Davies on 13/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVExpectation.h"

@interface BHVEqualityTests : SenTestCase
@end

@implementation BHVEqualityTests

- (void)testDoesNotThrowExceptionIfEqual
{
    BHVExpectation *expectation = [[BHVExpectation alloc] initWithSubject:@"foo"];
    [(id)expectation beEqualTo:@"foo"];
    STAssertNoThrow([expectation verify], @"Raised an exception, but should not have.");
}

- (void)testThrowsExceptionIfInequal
{
    BHVExpectation *expectation = [[BHVExpectation alloc] initWithSubject:@"foo"];
    [(id)expectation beEqualTo:@"bar"];
    STAssertNoThrow([expectation verify], @"Did not raise an exception, but should have.");
}

@end
