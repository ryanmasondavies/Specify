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
    STAssertTrue([sharedRegistry[0] isKindOfClass:[BHVSuiteRegistry class]], @"sharedRegistry did not return a suite registry.");
    STAssertTrue([sharedRegistry[1] isKindOfClass:[BHVSuiteRegistry class]], @"sharedRegistry did not return a suite registry.");
    STAssertEqualObjects(sharedRegistry[0], sharedRegistry[1], @"sharedRegistry did not return the same instance both times.");
}

- (void)testRegistersAndReturnsSuites
{
    BHVSuiteRegistry *registry = [[BHVSuiteRegistry alloc] init];
    BHVSuite *suite = [[BHVSuite alloc] init];
    [registry registerSuite:suite forClass:[self class]];
    STAssertEqualObjects([registry suiteForClass:[self class]], suite, @"BHVSuiteRegistry did not return the same suite as was registered with it.");
}

@end
