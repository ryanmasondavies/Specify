//
//  SPCGroupTests.m
//  Specify
//
//  Created by Ryan Davies on 30/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "SPCTestHelper.h"

@interface SPCGroupTests : SenTestCase
@end

@implementation SPCGroupTests

- (void)testAddingGroups
{
    SPCGroup *parentGroup = [SPCGroup new];
    SPCGroup *childGroup = [SPCGroup new];
    [parentGroup addGroup:childGroup];
    STAssertTrue([[parentGroup groups] containsObject:childGroup], @"Should have added child group to parent.");
    STAssertEqualObjects([childGroup parentGroup], parentGroup, @"Should have assigned the parent group.");
}

- (void)testAddingExamples
{
    SPCExample *example = [SPCExample new];
    SPCGroup *group = [SPCGroup new];
    [group addExample:example];
    STAssertTrue([[group examples] containsObject:example], @"Should have added example to group.");
    STAssertEqualObjects([example parentGroup], group, @"Should have assigned the parent group.");
}

- (void)testAddingHooks
{
    SPCBeforeEachHook *hook = [SPCBeforeEachHook new];
    SPCGroup *group = [SPCGroup new];
    [group addHook:hook];
    STAssertTrue([[group hooks] containsObject:hook], @"Should have added hook to group.");
    STAssertEqualObjects([hook parentGroup], group, @"Should have assigned the parent group.");
}

@end
