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

- (void)testSharedRegistryReturnsSameInstance
{
    id sharedRegistry[2];
    
    sharedRegistry[0] = [BHVSuiteRegistry sharedRegistry];
    sharedRegistry[1] = [BHVSuiteRegistry sharedRegistry];
    
    [[sharedRegistry[0] should] beKindOfClass:[BHVSuiteRegistry class]];
    [[sharedRegistry[1] should] beKindOfClass:[BHVSuiteRegistry class]];
    [[sharedRegistry[0] should] beEqualTo:sharedRegistry[1]];
}

- (void)testRegistersAndReturnsSuites
{
    BHVSuiteRegistry *registry = [[BHVSuiteRegistry alloc] init];
    BHVSuite *suite = [[BHVSuite alloc] init];
    [registry registerSuite:suite forClass:[self class]];
    [[[registry suiteForClass:[self class]] should] beEqualTo:suite];
}

@end
