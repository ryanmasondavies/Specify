//
//  BHVShould.h
//  Beehive
//
//  Created by Ryan Davies on 14/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "NSObject+BHVShould.h"
#import "BHVExpectation.h"

@interface BHVShouldTests : SenTestCase
@end

@implementation BHVShouldTests

- (void)testShouldCreatesExpectation
{
    id object = [NSObject new];
    BHVExpectation *expectation = [object should];
    STAssertEqualObjects([expectation subject], object, @"Expectation subject was not the object that -should was called on.");
}

@end
