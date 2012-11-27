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
    [[[invocations[0] example] should] beEqualTo:examples[0]];
    [[[invocations[1] example] should] beEqualTo:examples[1]];
    
    // Remove the suite:
    [[BHVSuiteRegistry sharedRegistry] removeAllSuites];
}

- (void)testRequestingInvocationsWhenAbstractClassReturnsEmptyArray
{
    [[@([[BHVSpec testInvocations] count]) should] beZero];
}

- (void)testNameReturnsNameOfCurrentExample
{
    BHVInvocation *invocation = [BHVInvocation emptyInvocation];
    BHVExample *example = [[BHVExample alloc] init];
    [example setName:@"Example 1"];
    [invocation setExample:example];
    
    BHVSpec *spec = [[BHVSpec alloc] initWithInvocation:invocation];
    [[[spec name] should] beEqualTo:@"Example 1"];
}

@end
