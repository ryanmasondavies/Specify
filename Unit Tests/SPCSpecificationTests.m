//
//  SPCSpecificationTests.m
//  Specify
//
//  Created by Ryan Davies on 30/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "SPCTestHelper.h"

@interface SPCSpecificationTests : SenTestCase
@end

@implementation SPCSpecificationTests

- (void)tearDown
{
    [SPCTestSpecification reset];
}

#pragma mark Builder

- (void)testBuilderPerSubclass
{
    STAssertFalse([SPCSpecificationA builder] == [SPCSpecificationB builder], @"Should have separate builders per subclass.");
}

#pragma mark Generating invocations

- (void)testCreatesInvocationsThatPerformTopLevelExamples
{
    // See the SPCSpecificationWithThreeExamples implementation to notice that it
    // adds three examples named Example 1, Example 2, and Example 3.
    
    NSArray *invocations = [SPCSpecificationWithThreeExamples testInvocations];
    STAssertEqualObjects([[invocations[0] example] name], @"example 1", @"Should execute example 1 first.");
    STAssertEqualObjects([[invocations[1] example] name], @"example 2", @"Should execute example 2 second.");
    STAssertEqualObjects([[invocations[2] example] name], @"example 3", @"Should execute example 3 third.");
}

- (void)testExamplesInGroupsAreMovedToEnd
{
    /* See the SPCSpecificationWithUnorderedNestedExamples implementation to
     * see that it creates the following structure:
     *   example 1
     *   {
     *     example 2
     *   }
     *   example 3
     *
     * SPCSpecification should shift examples in groups to the end of the invocation list.
     * Here, the second example is nested in a group. It should be executed last.
     */
    
    NSArray *invocations = [SPCSpecificationWithUnorderedNestedExamples testInvocations];
    STAssertEqualObjects([[invocations[0] example] name], @"example 1", @"Should perform example 1 first.");
    STAssertEqualObjects([[invocations[1] example] name], @"example 3", @"Should perform example 3 second.");
    STAssertEqualObjects([[invocations[2] example] name], @"example 2", @"Should perform example 2 last.");
}

- (void)testIgnoresHooks
{
    /* The SPCSpecificationWithHooks class has three hooks followed by an example.
     * SPCSpecification should not create invocations for the hooks, but should
     * ignore them and create an invocation for the example.
     */
    
    NSArray *invocations = [SPCSpecificationWithHooks testInvocations];
    STAssertTrue([invocations count] == 1, @"Should have 1 invocation: the example, and no hooks.");
    STAssertEqualObjects([[invocations[0] example] name], @"Example", @"Should execute the example.");
}

#pragma mark Generating names

- (void)testForwardsNameToExample
{
    id example = [OCMockObject mockForClass:[SPCExample class]];
    [[[example expect] andReturn:@"fake name"] fullName];
    SPCSpecification *specification = [[SPCSpecification alloc] initWithInvocation:[SPCInvocation invocationWithExample:example]];
    STAssertEqualObjects([specification name], @"fake name", @"");
    [example verify];
}

@end
