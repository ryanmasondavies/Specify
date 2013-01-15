//
//  BHVGroupTests.m
//  Behave
//
//  Created by Ryan Davies on 30/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVTestHelper.h"

@interface BHVGroupTests : SenTestCase
@end

@implementation BHVGroupTests

- (void)testAddingGroups
{
    BHVGroup *parentGroup = [BHVGroup new];
    BHVGroup *childGroup = [BHVGroup new];
    [parentGroup addGroup:childGroup];
    STAssertTrue([[parentGroup groups] containsObject:childGroup], @"Should have added child group to parent.");
    STAssertEqualObjects([childGroup parentGroup], parentGroup, @"Should have assigned the parent group.");
}

- (void)testAddingExamples
{
    BHVExample *example = [BHVExample new];
    BHVGroup *group = [BHVGroup new];
    [group addExample:example];
    STAssertTrue([[group examples] containsObject:example], @"Should have added example to group.");
    STAssertEqualObjects([example parentGroup], group, @"Should have assigned the parent group.");
}

- (void)testAddingHooks
{
    BHVBeforeEachHook *hook = [BHVBeforeEachHook new];
    BHVGroup *group = [BHVGroup new];
    [group addHook:hook];
    STAssertTrue([[group hooks] containsObject:hook], @"Should have added hook to group.");
    STAssertEqualObjects([hook parentGroup], group, @"Should have assigned the parent group.");
}

@end
