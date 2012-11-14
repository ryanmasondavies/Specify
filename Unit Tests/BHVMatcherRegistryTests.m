//
//  BHVMatcherRegistryTests.m
//  Beehive
//
//  Created by Ryan Davies on 14/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVMatcherRegistry.h"
#import "BHVMatcher.h"

@interface BHVSampleMatcher : BHVMatcher
@end

@implementation BHVSampleMatcher
@end

@interface BHVMatcherRegistryTests : SenTestCase
@end

@implementation BHVMatcherRegistryTests

- (void)testSharedRegistryReturnsSameInstance
{
    id sharedRegistry[2];
    sharedRegistry[0] = [BHVMatcherRegistry sharedRegistry];
    sharedRegistry[1] = [BHVMatcherRegistry sharedRegistry];
    STAssertTrue([sharedRegistry[0] isKindOfClass:[BHVMatcherRegistry class]], @"sharedRegistry did not return a matcher registry.");
    STAssertTrue([sharedRegistry[1] isKindOfClass:[BHVMatcherRegistry class]], @"sharedRegistry did not return a matcher registry.");
    STAssertEqualObjects(sharedRegistry[0], sharedRegistry[1], @"sharedRegistry did not return the same instance both times.");
}

- (void)testRegistersSubclassesOfBHVMatcherOnInitialization
{
    BHVMatcherRegistry *registry = [[BHVMatcherRegistry alloc] init];
    STAssertTrue([[registry registeredClasses] containsObject:[BHVSampleMatcher class]], @"BHVSampleMatcher was not registered as a matcher class.");
}

@end
