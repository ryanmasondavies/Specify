//
//  BHVSpecTests.m
//  Beehive
//
//  Created by Ryan Davies on 12/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVSpec.h"
#import "BHVTestHelper.h"
#import "BHVSuiteRegistry.h"
#import "BHVSuite.h"
#import "BHVExample.h"
#import "BHVInvocation.h"

@interface BHVSpecTests : SenTestCase
@end

@implementation BHVSpecTests

- (void)testReturnsInvocationsForCompiledExamples
{
    // Create and register an unlocked suite:
    BHVSuite *suite = [[BHVSuite alloc] init];
    [suite setLocked:NO];
    [[BHVSuiteRegistry sharedRegistry] registerSuite:suite forClass:[BHVTestSpec1 class]];
    
    // Create two examples and add them to the suite:
    NSMutableArray *examples = [NSMutableArray array];
    examples[0] = [[BHVExample alloc] init];
    examples[1] = [[BHVExample alloc] init];
    [suite addNode:examples[0]];
    [suite addNode:examples[1]];
    
    // Retrieve the spec invocations:
    NSArray *invocations = [BHVTestSpec1 testInvocations];
    STAssertEqualObjects([invocations[0] example], examples[0], @"Expected invocation 1 to be for example 1.");
    STAssertEqualObjects([invocations[1] example], examples[1], @"Expected invocation 2 to be for example 2.");
    
    // Remove the suite:
    [[BHVSuiteRegistry sharedRegistry] removeAllSuites];
}

- (void)testRequestingInvocationsWhenAbstractClassReturnsEmptyArray
{
    STAssertTrue([[BHVSpec testInvocations] count] == 0, @"Expected there to be no invocations.");
}

- (void)testNameReturnsNameOfCurrentExample
{
    BHVInvocation *invocation = [BHVInvocation emptyInvocation];
    BHVExample *example = [[BHVExample alloc] init];
    [example setName:@"Example 1"];
    [invocation setExample:example];
    
    BHVSpec *spec = [[BHVSpec alloc] initWithInvocation:invocation];
    STAssertEquals([spec name], @"Example 1", @"Expected spec name to match the name of the example.");
}

@end
