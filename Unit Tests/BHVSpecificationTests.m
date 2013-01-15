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
    
    STAssertEqualObjects([examples[0] parentContext], [examples[1] parentContext], @"Should have added both examples to the same context.");
}

- (void)testNestingExamples
{
    NSArray *contexts = @[[BHVContext new], [BHVContext new]];
    NSArray *examples = @[[BHVExample new], [BHVExample new]];
    
    [BHVTestSpecification enterContext:contexts[0]];
    [BHVTestSpecification addExample:examples[0]];
    [BHVTestSpecification leaveContext];
    [BHVTestSpecification enterContext:contexts[1]];
    [BHVTestSpecification addExample:examples[1]];
    [BHVTestSpecification leaveContext];
    
    STAssertEqualObjects([contexts[0] parentContext], [contexts[1] parentContext], @"Should have added both contexts to the same context.");
    STAssertEqualObjects([examples[0] parentContext], contexts[0], @"Should have added example 1 to context 1.");
    STAssertEqualObjects([examples[1] parentContext], contexts[1], @"Should have added example 2 to context 2.");
}

- (void)testNestingExamplesInNestedContexts
{
    NSArray *contexts = @[[BHVContext new], [BHVContext new], [BHVContext new]];
    NSArray *examples = @[[BHVExample new], [BHVExample new], [BHVExample new]];
    
    [BHVTestSpecification enterContext:contexts[0]];
    [BHVTestSpecification addExample:examples[0]];
    [BHVTestSpecification enterContext:contexts[1]];
    [BHVTestSpecification addExample:examples[1]];
    [BHVTestSpecification enterContext:contexts[2]];
    [BHVTestSpecification addExample:examples[2]];
    [BHVTestSpecification leaveContext];
    [BHVTestSpecification leaveContext];
    [BHVTestSpecification leaveContext];
    
    STAssertNotNil([contexts[0] parentContext], @"Should have added context 1 to base context.");
    STAssertEqualObjects([contexts[1] parentContext], contexts[0], @"Should have added context 2 to context 1.");
    STAssertEqualObjects([contexts[2] parentContext], contexts[1], @"Should have added context 3 to context 2.");
    STAssertEqualObjects([examples[0] parentContext], contexts[0], @"Should have added example 1 to context 1.");
    STAssertEqualObjects([examples[1] parentContext], contexts[1], @"Should have added example 2 to context 2.");
    STAssertEqualObjects([examples[2] parentContext], contexts[2], @"Should have added example 3 to context 3.");
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
    
    STAssertEqualObjects([hooks[0] parentContext], [hooks[1] parentContext], @"Should have added both hooks to the same context.");
}

- (void)testNestingHooks
{
    NSArray *contexts = @[[BHVContext new], [BHVContext new]];
    NSArray *hooks = @[[BHVBeforeEachHook new], [BHVBeforeEachHook new]];
    
    [BHVTestSpecification enterContext:contexts[0]];
    [BHVTestSpecification addExample:hooks[0]];
    [BHVTestSpecification leaveContext];
    [BHVTestSpecification enterContext:contexts[1]];
    [BHVTestSpecification addExample:hooks[1]];
    [BHVTestSpecification leaveContext];
    
    STAssertEqualObjects([contexts[0] parentContext], [contexts[1] parentContext], @"Should have added both contexts to the same context.");
    STAssertEqualObjects([hooks[0] parentContext], contexts[0], @"Should have added hook 1 to context 1.");
    STAssertEqualObjects([hooks[1] parentContext], contexts[1], @"Should have added hook 2 to context 2.");
}

- (void)testNestingHooksInNestedContexts
{
    NSArray *contexts = @[[BHVContext new], [BHVContext new], [BHVContext new]];
    NSArray *hooks    = @[[BHVBeforeEachHook    new], [BHVBeforeEachHook    new], [BHVBeforeEachHook    new]];
    
    [BHVTestSpecification enterContext:contexts[0]];
    [BHVTestSpecification addHook:hooks[0]];
    [BHVTestSpecification enterContext:contexts[1]];
    [BHVTestSpecification addHook:hooks[1]];
    [BHVTestSpecification enterContext:contexts[2]];
    [BHVTestSpecification addHook:hooks[2]];
    [BHVTestSpecification leaveContext];
    [BHVTestSpecification leaveContext];
    [BHVTestSpecification leaveContext];
    
    STAssertNotNil([contexts[0] parentContext], @"Should have added context 1 to base context.");
    STAssertEqualObjects([contexts[1] parentContext], contexts[0], @"Should have added context 2 to context 1.");
    STAssertEqualObjects([contexts[2] parentContext], contexts[1], @"Should have added context 3 to context 2.");
    STAssertEqualObjects([hooks[0] parentContext], contexts[0], @"Should have added hook 1 to context 1.");
    STAssertEqualObjects([hooks[1] parentContext], contexts[1], @"Should have added hook 2 to context 2.");
    STAssertEqualObjects([hooks[2] parentContext], contexts[2], @"Should have added hook 3 to context 3.");
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

- (void)testExamplesInContextsAreMovedToEnd
{
    /* See the BHVSpecificationWithUnorderedNestedExamples implementation to
     * see that it creates the following structure:
     *   example 1
     *   {
     *     example 2
     *   }
     *   example 3
     *
     * BHVSpecification should shift examples in contexts to the end of the invocation list.
     * Here, the second example is nested in a context. It should be executed last.
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

#pragma mark Generating contextual names

- (void)testConcatenatesContextNamesAndExampleName
{
    // Create contexts:
    NSArray *contexts = @[[BHVContext new], [BHVContext new]];
    [contexts[0] setName:@"a cat"];
    [contexts[1] setName:@"when it is fat"];
    
    // Create an example:
    BHVExample *example = [[BHVExample alloc] init];
    [example setName:@"should be lazy"];
    
    // Nest example in contexts:
    [BHVTestSpecification enterContext:contexts[0]];
    [BHVTestSpecification enterContext:contexts[1]];
    [BHVTestSpecification addExample:example];
    [BHVTestSpecification leaveContext];
    [BHVTestSpecification leaveContext];
    
    // Test that the name is equal to the concatenated context names and example name:
    BHVTestSpecification *spec = [BHVTestSpecification testCaseWithInvocation:[BHVInvocation invocationWithExample:example]];
    STAssertEqualObjects([spec name], @"a cat when it is fat should be lazy", @"Should have returned the concatenated names of the contexts and example.");
}

- (void)testIgnoresHooksForContextualNames
{
    // Create contexts:
    NSArray *contexts = @[[BHVContext new], [BHVContext new]];
    [contexts[0] setName:@"a cat"];
    [contexts[1] setName:@"when it is fat"];
    
    // Create an example:
    BHVExample *example = [[BHVExample alloc] init];
    [example setName:@"should be lazy"];
    
    // Nest example in contexts, and add some hooks:
    [BHVTestSpecification enterContext:contexts[0]];
    [BHVTestSpecification addHook:[BHVBeforeEachHook new]];
    [BHVTestSpecification enterContext:contexts[1]];
    [BHVTestSpecification addHook:[BHVBeforeEachHook new]];
    [BHVTestSpecification addExample:example];
    [BHVTestSpecification addHook:[BHVBeforeEachHook new]];
    [BHVTestSpecification leaveContext];
    [BHVTestSpecification addHook:[BHVBeforeEachHook new]];
    [BHVTestSpecification leaveContext];
    
    // Test that the name is equal to the concatenated context names and example name:
    BHVTestSpecification *spec = [BHVTestSpecification testCaseWithInvocation:[BHVInvocation invocationWithExample:example]];
    STAssertEqualObjects([spec name], @"a cat when it is fat should be lazy", @"Should have returned the concatenated names of the contexts and example.");
}

- (void)testUsesJustExampleNameIfNotInContext
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
