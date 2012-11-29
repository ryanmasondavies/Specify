//
//  BHVSuiteRegistryTests.m
//  Beehive
//
//  Created by Ryan Davies on 13/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVSuiteRegistry.h"
#import "BHVSuite.h"

@interface BHVSuiteRegistryTests : SenTestCase
@end

@implementation BHVSuiteRegistryTests

- (void)testRegistersAndReturnsSuites
{
    BHVSuite *suite = [[BHVSuite alloc] init];
    [BHVSuiteRegistry registerSuite:suite forClass:[self class]];
    [[[BHVSuiteRegistry suiteForClass:[self class]] should] beEqualTo:suite];
    [BHVSuiteRegistry removeAllSuites];
}

@end
