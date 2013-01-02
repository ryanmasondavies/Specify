//
//  BHVSpecificationTests.m
//  Behave
//
//  Created by Ryan Davies on 30/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "BHVTestHelper.h"
#import "BHVSpecification.h"
#import "BHVContext.h"
#import "BHVExample.h"
#import "BHVHook.h"

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

#pragma mark Generating invocations

- (void)testCreatesInvocationsThatPerformExamples
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
    [BHVTestSpecification addHook:[BHVHook new]];
    [BHVTestSpecification enterContext:contexts[1]];
    [BHVTestSpecification addHook:[BHVHook new]];
    [BHVTestSpecification addExample:example];
    [BHVTestSpecification addHook:[BHVHook new]];
    [BHVTestSpecification leaveContext];
    [BHVTestSpecification addHook:[BHVHook new]];
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
