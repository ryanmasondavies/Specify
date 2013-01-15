//
//  BHVBuilderTests.m
//  Behave
//
//  Created by Ryan Davies on 15/01/2013.
//  Copyright (c) 2013 Ryan Davies. All rights reserved.
//

#import "BHVTestHelper.h"

@interface BHVBuilderTests : SenTestCase
@property (strong, nonatomic) BHVBuilder *builder;
@end

@implementation BHVBuilderTests

- (void)setUp
{
    self.builder = [[BHVBuilder alloc] init];
}

#pragma mark Adding examples

- (void)testAddingExamples
{
    NSMutableArray *examples = [NSMutableArray array];
    for (NSUInteger i = 0; i < 2; i ++) {
        examples[i] = [[BHVExample alloc] init];
        [[self builder] addExample:examples[i]];
    }
    
    STAssertEqualObjects([examples[0] parentGroup], [examples[1] parentGroup], @"Should have added both examples to the same group.");
}

- (void)testNestingExamples
{
    NSArray *groups = @[[BHVGroup new], [BHVGroup new]];
    NSArray *examples = @[[BHVExample new], [BHVExample new]];
    
    [[self builder] enterGroup:groups[0]];
    [[self builder] addExample:examples[0]];
    [[self builder] leaveGroup];
    [[self builder] enterGroup:groups[1]];
    [[self builder] addExample:examples[1]];
    [[self builder] leaveGroup];
    
    STAssertEqualObjects([groups[0] parentGroup], [groups[1] parentGroup], @"Should have added both groups to the same group.");
    STAssertEqualObjects([examples[0] parentGroup], groups[0], @"Should have added example 1 to group 1.");
    STAssertEqualObjects([examples[1] parentGroup], groups[1], @"Should have added example 2 to group 2.");
}

- (void)testNestingExamplesInNestedGroups
{
    NSArray *groups = @[[BHVGroup new], [BHVGroup new], [BHVGroup new]];
    NSArray *examples = @[[BHVExample new], [BHVExample new], [BHVExample new]];
    
    [[self builder] enterGroup:groups[0]];
    [[self builder] addExample:examples[0]];
    [[self builder] enterGroup:groups[1]];
    [[self builder] addExample:examples[1]];
    [[self builder] enterGroup:groups[2]];
    [[self builder] addExample:examples[2]];
    [[self builder] leaveGroup];
    [[self builder] leaveGroup];
    [[self builder] leaveGroup];
    
    STAssertNotNil([groups[0] parentGroup], @"Should have added group 1 to base group.");
    STAssertEqualObjects([groups[1] parentGroup], groups[0], @"Should have added group 2 to group 1.");
    STAssertEqualObjects([groups[2] parentGroup], groups[1], @"Should have added group 3 to group 2.");
    STAssertEqualObjects([examples[0] parentGroup], groups[0], @"Should have added example 1 to group 1.");
    STAssertEqualObjects([examples[1] parentGroup], groups[1], @"Should have added example 2 to group 2.");
    STAssertEqualObjects([examples[2] parentGroup], groups[2], @"Should have added example 3 to group 3.");
}

#pragma mark Adding hooks

- (void)testAddingHooks
{
    NSMutableArray *hooks = [NSMutableArray array];
    for (NSUInteger i = 0; i < 2; i ++) {
        hooks[i] = [[BHVHook alloc] init];
        [[self builder] addHook:hooks[i]];
    }
    
    STAssertEqualObjects([hooks[0] parentGroup], [hooks[1] parentGroup], @"Should have added both hooks to the same group.");
}

- (void)testNestingHooks
{
    NSArray *groups = @[[BHVGroup new], [BHVGroup new]];
    NSArray *hooks = @[[BHVHook new], [BHVHook new]];
    
    [[self builder] enterGroup:groups[0]];
    [[self builder] addExample:hooks[0]];
    [[self builder] leaveGroup];
    [[self builder] enterGroup:groups[1]];
    [[self builder] addExample:hooks[1]];
    [[self builder] leaveGroup];
    
    STAssertEqualObjects([groups[0] parentGroup], [groups[1] parentGroup], @"Should have added both groups to the same group.");
    STAssertEqualObjects([hooks[0] parentGroup], groups[0], @"Should have added hook 1 to group 1.");
    STAssertEqualObjects([hooks[1] parentGroup], groups[1], @"Should have added hook 2 to group 2.");
}

- (void)testNestingHooksInNestedGroups
{
    NSArray *groups = @[[BHVGroup new], [BHVGroup new], [BHVGroup new]];
    NSArray *hooks    = @[[BHVHook    new], [BHVHook    new], [BHVHook    new]];
    
    [[self builder] enterGroup:groups[0]];
    [[self builder] addHook:hooks[0]];
    [[self builder] enterGroup:groups[1]];
    [[self builder] addHook:hooks[1]];
    [[self builder] enterGroup:groups[2]];
    [[self builder] addHook:hooks[2]];
    [[self builder] leaveGroup];
    [[self builder] leaveGroup];
    [[self builder] leaveGroup];
    
    STAssertNotNil([groups[0] parentGroup], @"Should have added group 1 to base group.");
    STAssertEqualObjects([groups[1] parentGroup], groups[0], @"Should have added group 2 to group 1.");
    STAssertEqualObjects([groups[2] parentGroup], groups[1], @"Should have added group 3 to group 2.");
    STAssertEqualObjects([hooks[0] parentGroup], groups[0], @"Should have added hook 1 to group 1.");
    STAssertEqualObjects([hooks[1] parentGroup], groups[1], @"Should have added hook 2 to group 2.");
    STAssertEqualObjects([hooks[2] parentGroup], groups[2], @"Should have added hook 3 to group 3.");
}

@end
