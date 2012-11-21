//
//  BHVSuiteTests.m
//  Beehive
//
//  Created by Ryan Davies on 12/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVSuite.h"
#import "BHVExample.h"

@interface BHVSuiteTests : SenTestCase
@end

@implementation BHVSuiteTests

- (void)testRaisesAnExceptionWhenAddingExamplesWhileLocked
{
    BHVSuite *suite = [[BHVSuite alloc] init];
    BHVExample *example = [[BHVExample alloc] init];
    STAssertThrows([suite addExample:example], @"-addExample: should have thrown an exception.");
}

- (void)testAddsExamplesWhenUnlocked
{
    BHVSuite *suite = [[BHVSuite alloc] init];
    BHVExample *example = [[BHVExample alloc] init];
    [suite unlock];
    [suite addExample:example];
    STAssertEqualObjects([suite exampleAtIndex:0], example, @"-exampleAtIndex: should have returned the example that was added to the suite.");
}

@end
