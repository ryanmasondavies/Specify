//
//  BHVSpecificationTests.m
//  Behave
//
//  Created by Ryan Davies on 30/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVTestHelper.h"

@interface BHVInvocation : NSInvocation
@property (strong, nonatomic) BHVExample *example;
+ (instancetype)invocationWithExample:(BHVExample *)example;
@end

@interface BHVSpecificationTests : SenTestCase
@end

@implementation BHVSpecificationTests

- (void)tearDown
{
    [BHVTestSpecification reset];
}

#pragma mark Adding examples

- (void)testExamplesCannotBeAddedToBaseClass
{
    STAssertThrows([BHVSpecification addExample:[BHVExample new]], @"Should not be able to add examples to the base class.");
}

- (void)testAddingExamples
{
    NSMutableArray *examples = [NSMutableArray array];
    for (NSUInteger i = 0; i < 2; i ++) {
        examples[i] = [[BHVExample alloc] init];
        [BHVTestSpecification addExample:examples[i]];
    }
    
    STAssertEqualObjects([examples[0] parentGroup], [examples[1] parentGroup], @"Should have added both examples to the same group.");
}

- (void)testNestingExamples
{
    NSArray *groups = @[[BHVGroup new], [BHVGroup new]];
    NSArray *examples = @[[BHVExample new], [BHVExample new]];
    
    [BHVTestSpecification enterGroup:groups[0]];
    [BHVTestSpecification addExample:examples[0]];
    [BHVTestSpecification leaveGroup];
    [BHVTestSpecification enterGroup:groups[1]];
    [BHVTestSpecification addExample:examples[1]];
    [BHVTestSpecification leaveGroup];
    
    STAssertEqualObjects([groups[0] parentGroup], [groups[1] parentGroup], @"Should have added both groups to the same group.");
    STAssertEqualObjects([examples[0] parentGroup], groups[0], @"Should have added example 1 to group 1.");
    STAssertEqualObjects([examples[1] parentGroup], groups[1], @"Should have added example 2 to group 2.");
}

- (void)testNestingExamplesInNestedGroups
{
    NSArray *groups = @[[BHVGroup new], [BHVGroup new], [BHVGroup new]];
    NSArray *examples = @[[BHVExample new], [BHVExample new], [BHVExample new]];
    
    [BHVTestSpecification enterGroup:groups[0]];
    [BHVTestSpecification addExample:examples[0]];
    [BHVTestSpecification enterGroup:groups[1]];
    [BHVTestSpecification addExample:examples[1]];
    [BHVTestSpecification enterGroup:groups[2]];
    [BHVTestSpecification addExample:examples[2]];
    [BHVTestSpecification leaveGroup];
    [BHVTestSpecification leaveGroup];
    [BHVTestSpecification leaveGroup];
    
    STAssertNotNil([groups[0] parentGroup], @"Should have added group 1 to base group.");
    STAssertEqualObjects([groups[1] parentGroup], groups[0], @"Should have added group 2 to group 1.");
    STAssertEqualObjects([groups[2] parentGroup], groups[1], @"Should have added group 3 to group 2.");
    STAssertEqualObjects([examples[0] parentGroup], groups[0], @"Should have added example 1 to group 1.");
    STAssertEqualObjects([examples[1] parentGroup], groups[1], @"Should have added example 2 to group 2.");
    STAssertEqualObjects([examples[2] parentGroup], groups[2], @"Should have added example 3 to group 3.");
}

#pragma mark Adding hooks

- (void)testHooksCannotBeAddedToBaseClass
{
    STAssertThrows([BHVSpecification addExample:[BHVExample new]], @"Should not be able to add examples to the base class.");
}

- (void)testAddingHooks
{
    NSMutableArray *hooks = [NSMutableArray array];
    for (NSUInteger i = 0; i < 2; i ++) {
        hooks[i] = [[BHVBeforeEachHook alloc] init];
        [BHVTestSpecification addHook:hooks[i]];
    }
    
    STAssertEqualObjects([hooks[0] parentGroup], [hooks[1] parentGroup], @"Should have added both hooks to the same group.");
}

- (void)testNestingHooks
{
    NSArray *groups = @[[BHVGroup new], [BHVGroup new]];
    NSArray *hooks = @[[BHVBeforeEachHook new], [BHVBeforeEachHook new]];
    
    [BHVTestSpecification enterGroup:groups[0]];
    [BHVTestSpecification addExample:hooks[0]];
    [BHVTestSpecification leaveGroup];
    [BHVTestSpecification enterGroup:groups[1]];
    [BHVTestSpecification addExample:hooks[1]];
    [BHVTestSpecification leaveGroup];
    
    STAssertEqualObjects([groups[0] parentGroup], [groups[1] parentGroup], @"Should have added both groups to the same group.");
    STAssertEqualObjects([hooks[0] parentGroup], groups[0], @"Should have added hook 1 to group 1.");
    STAssertEqualObjects([hooks[1] parentGroup], groups[1], @"Should have added hook 2 to group 2.");
}

- (void)testNestingHooksInNestedGroups
{
    NSArray *groups = @[[BHVGroup new], [BHVGroup new], [BHVGroup new]];
    NSArray *hooks    = @[[BHVBeforeEachHook    new], [BHVBeforeEachHook    new], [BHVBeforeEachHook    new]];
    
    [BHVTestSpecification enterGroup:groups[0]];
    [BHVTestSpecification addHook:hooks[0]];
    [BHVTestSpecification enterGroup:groups[1]];
    [BHVTestSpecification addHook:hooks[1]];
    [BHVTestSpecification enterGroup:groups[2]];
    [BHVTestSpecification addHook:hooks[2]];
    [BHVTestSpecification leaveGroup];
    [BHVTestSpecification leaveGroup];
    [BHVTestSpecification leaveGroup];
    
    STAssertNotNil([groups[0] parentGroup], @"Should have added group 1 to base group.");
    STAssertEqualObjects([groups[1] parentGroup], groups[0], @"Should have added group 2 to group 1.");
    STAssertEqualObjects([groups[2] parentGroup], groups[1], @"Should have added group 3 to group 2.");
    STAssertEqualObjects([hooks[0] parentGroup], groups[0], @"Should have added hook 1 to group 1.");
    STAssertEqualObjects([hooks[1] parentGroup], groups[1], @"Should have added hook 2 to group 2.");
    STAssertEqualObjects([hooks[2] parentGroup], groups[2], @"Should have added hook 3 to group 3.");
}

#pragma mark Generating invocations

- (void)testCreatesInvocationsThatPerformTopLevelExamples
{
    // See the BHVSpecificationWithThreeExamples implementation to notice that it
    // adds three examples named Example 1, Example 2, and Example 3.
    
    NSArray *invocations = [BHVSpecificationWithThreeExamples testInvocations];
    STAssertEqualObjects([[invocations[0] example] name], @"example 1", @"Should execute example 1 first.");
    STAssertEqualObjects([[invocations[1] example] name], @"example 2", @"Should execute example 2 second.");
    STAssertEqualObjects([[invocations[2] example] name], @"example 3", @"Should execute example 3 third.");
}

- (void)testExamplesInGroupsAreMovedToEnd
{
    /* See the BHVSpecificationWithUnorderedNestedExamples implementation to
     * see that it creates the following structure:
     *   example 1
     *   {
     *     example 2
     *   }
     *   example 3
     *
     * BHVSpecification should shift examples in groups to the end of the invocation list.
     * Here, the second example is nested in a group. It should be executed last.
     */
    
    NSArray *invocations = [BHVSpecificationWithUnorderedNestedExamples testInvocations];
    STAssertEqualObjects([[invocations[0] example] name], @"example 1", @"Should perform example 1 first.");
    STAssertEqualObjects([[invocations[1] example] name], @"example 3", @"Should perform example 3 second.");
    STAssertEqualObjects([[invocations[2] example] name], @"example 2", @"Should perform example 2 last.");
}

- (void)testIgnoresHooks
{
    /* The BHVSpecificationWithHooks class has three hooks followed by an example.
     * BHVSpecification should not create invocations for the hooks, but should
     * ignore them and create an invocation for the example.
     */
    
    NSArray *invocations = [BHVSpecificationWithHooks testInvocations];
    STAssertTrue([invocations count] == 1, @"Should have 1 invocation: the example, and no hooks.");
    STAssertEqualObjects([[invocations[0] example] name], @"Example", @"Should execute the example.");
}

#pragma mark Generating groupual names

- (void)testConcatenatesGroupNamesAndExampleName
{
    // Create groups:
    NSArray *groups = @[[BHVGroup new], [BHVGroup new]];
    [groups[0] setName:@"a cat"];
    [groups[1] setName:@"when it is fat"];
    
    // Create an example:
    BHVExample *example = [[BHVExample alloc] init];
    [example setName:@"should be lazy"];
    
    // Nest example in groups:
    [BHVTestSpecification enterGroup:groups[0]];
    [BHVTestSpecification enterGroup:groups[1]];
    [BHVTestSpecification addExample:example];
    [BHVTestSpecification leaveGroup];
    [BHVTestSpecification leaveGroup];
    
    // Test that the name is equal to the concatenated group names and example name:
    BHVTestSpecification *spec = [BHVTestSpecification testCaseWithInvocation:[BHVInvocation invocationWithExample:example]];
    STAssertEqualObjects([spec name], @"a cat when it is fat should be lazy", @"Should have returned the concatenated names of the groups and example.");
}

- (void)testIgnoresHooksForGroupualNames
{
    // Create groups:
    NSArray *groups = @[[BHVGroup new], [BHVGroup new]];
    [groups[0] setName:@"a cat"];
    [groups[1] setName:@"when it is fat"];
    
    // Create an example:
    BHVExample *example = [[BHVExample alloc] init];
    [example setName:@"should be lazy"];
    
    // Nest example in groups, and add some hooks:
    [BHVTestSpecification enterGroup:groups[0]];
    [BHVTestSpecification addHook:[BHVBeforeEachHook new]];
    [BHVTestSpecification enterGroup:groups[1]];
    [BHVTestSpecification addHook:[BHVBeforeEachHook new]];
    [BHVTestSpecification addExample:example];
    [BHVTestSpecification addHook:[BHVBeforeEachHook new]];
    [BHVTestSpecification leaveGroup];
    [BHVTestSpecification addHook:[BHVBeforeEachHook new]];
    [BHVTestSpecification leaveGroup];
    
    // Test that the name is equal to the concatenated group names and example name:
    BHVTestSpecification *spec = [BHVTestSpecification testCaseWithInvocation:[BHVInvocation invocationWithExample:example]];
    STAssertEqualObjects([spec name], @"a cat when it is fat should be lazy", @"Should have returned the concatenated names of the groups and example.");
}

- (void)testUsesJustExampleNameIfNotInGroup
{
    // Create and add an example to the spec:
    BHVExample *example = [[BHVExample alloc] init];
    [example setName:@"hello world"];
    [BHVTestSpecification addExample:example];
    
    // Test that the name is equal to the example name:
    BHVTestSpecification *spec = [BHVTestSpecification testCaseWithInvocation:[BHVInvocation invocationWithExample:example]];
    STAssertEqualObjects([spec name], @"hello world", @"Should have returned the name of the example.");
}

@end
