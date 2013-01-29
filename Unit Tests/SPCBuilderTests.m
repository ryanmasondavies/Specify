//
//  SPCBuilderTests.m
//  Specify
//
//  Created by Ryan Davies on 15/01/2013.
//  Copyright (c) 2013 Ryan Davies. All rights reserved.
//

#import "SPCTestHelper.h"

@interface SPCBuilderTests : SenTestCase
@property (strong, nonatomic) SPCBuilder *builder;
@end

@implementation SPCBuilderTests

- (void)setUp
{
    self.builder = [[SPCBuilder alloc] init];
}

#pragma mark Adding examples

- (void)testAddingExamples
{
    SPCExample *example = [[SPCExample alloc] init];
    [[self builder] addExample:example];
    STAssertEqualObjects([example parent], [[self builder] rootGroup], @"Should add examples to the root group.");
}

- (void)testNestingExamples
{
    INLGroup *group = [[INLGroup alloc] init];
    SPCExample *example = [[SPCExample alloc] init];
    
    [[self builder] enterGroup:group];
    [[self builder] addExample:example];
    [[self builder] leaveGroup];
    
    STAssertEqualObjects([[self builder] rootGroup], [group parent], @"Should add groups to the root group.");
    STAssertEqualObjects([example parent], group, @"Should have added example to group.");
}

- (void)testNestingExamplesInNestedGroups
{
    NSArray *groups = @[[INLGroup new], [INLGroup new], [INLGroup new]];
    NSArray *examples = @[[SPCExample new], [SPCExample new], [SPCExample new]];
    
    [[self builder] enterGroup:groups[0]];
    [[self builder] addExample:examples[0]];
    [[self builder] enterGroup:groups[1]];
    [[self builder] addExample:examples[1]];
    [[self builder] enterGroup:groups[2]];
    [[self builder] addExample:examples[2]];
    [[self builder] leaveGroup];
    [[self builder] leaveGroup];
    [[self builder] leaveGroup];
    
    STAssertEqualObjects([groups[0] parent], [[self builder] rootGroup], @"Should have added group 1 to root group.");
    STAssertEqualObjects([groups[1] parent], groups[0], @"Should have added group 2 to group 1.");
    STAssertEqualObjects([groups[2] parent], groups[1], @"Should have added group 3 to group 2.");
    STAssertEqualObjects([examples[0] parent], groups[0], @"Should have added example 1 to group 1.");
    STAssertEqualObjects([examples[1] parent], groups[1], @"Should have added example 2 to group 2.");
    STAssertEqualObjects([examples[2] parent], groups[2], @"Should have added example 3 to group 3.");
}

#pragma mark Adding hooks

- (void)testAddingHooks
{
    SPCHook *hook = [[SPCHook alloc] init];
    [[self builder] addHook:hook];
    STAssertEqualObjects([hook parent], [[self builder] rootGroup], @"Should add hooks to the root group.");
}

- (void)testNestingHooks
{
    INLGroup *group = [[INLGroup alloc] init];
    SPCHook *hook = [[SPCHook alloc] init];
    
    [[self builder] enterGroup:group];
    [[self builder] addHook:hook];
    [[self builder] leaveGroup];
    
    STAssertEqualObjects([[self builder] rootGroup], [group parent], @"Should add groups to the root group.");
    STAssertEqualObjects([hook parent], group, @"Should have added hook to group.");
}

- (void)testNestingHooksInNestedGroups
{
    NSArray *groups = @[[INLGroup new], [INLGroup new], [INLGroup new]];
    NSArray *hooks = @[[SPCHook new], [SPCHook new], [SPCHook new]];
    
    [[self builder] enterGroup:groups[0]];
    [[self builder] addHook:hooks[0]];
    [[self builder] enterGroup:groups[1]];
    [[self builder] addHook:hooks[1]];
    [[self builder] enterGroup:groups[2]];
    [[self builder] addHook:hooks[2]];
    [[self builder] leaveGroup];
    [[self builder] leaveGroup];
    [[self builder] leaveGroup];
    
    STAssertEqualObjects([groups[0] parent], [[self builder] rootGroup], @"Should have added group 1 to root group.");
    STAssertEqualObjects([groups[1] parent], groups[0], @"Should have added group 2 to group 1.");
    STAssertEqualObjects([groups[2] parent], groups[1], @"Should have added group 3 to group 2.");
    STAssertEqualObjects([hooks[0] parent], groups[0], @"Should have added hook 1 to group 1.");
    STAssertEqualObjects([hooks[1] parent], groups[1], @"Should have added hook 2 to group 2.");
    STAssertEqualObjects([hooks[2] parent], groups[2], @"Should have added hook 3 to group 3.");
}

@end
