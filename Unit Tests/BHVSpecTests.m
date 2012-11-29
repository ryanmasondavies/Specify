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

Class recordedSpec = nil;

@interface BHVCurrentSpecRecorderSpec : BHVSpec
@end

@implementation BHVCurrentSpecRecorderSpec

- (void)loadExamples
{
    recordedSpec = [BHVSpec currentSpec];
}

@end

@interface BHVSpecTests : SenTestCase
@end

@implementation BHVSpecTests

- (void)testCurrentSpecIsSetWhenLoadingExamples
{
    recordedSpec = nil;
    [BHVCurrentSpecRecorderSpec initialize];
    [[recordedSpec should] beIdenticalTo:[BHVCurrentSpecRecorderSpec class]];
}

- (void)testReturnsInvocationsForCompiledExamples
{
    // Create a suite:
    BHVSuite *suite = [[BHVSuite alloc] init];
    
    // Create two examples and add them to the suite:
    NSMutableArray *examples = [NSMutableArray array];
    examples[0] = [[BHVExample alloc] init];
    examples[1] = [[BHVExample alloc] init];
    [suite addNode:examples[0]];
    [suite addNode:examples[1]];
    
    // Lock it and add it to the registry:
    [suite setLocked:YES];
    [BHVSuiteRegistry registerSuite:suite forClass:[BHVTestSpec1 class]];
    
    // Retrieve the spec invocations:
    NSArray *invocations = [BHVTestSpec1 testInvocations];
    [[[invocations[0] example] should] beEqualTo:examples[0]];
    [[[invocations[1] example] should] beEqualTo:examples[1]];
    
    // Remove the suite:
    [BHVSuiteRegistry removeAllSuites];
}

- (void)testRequestingInvocationsWhenAbstractClassReturnsEmptyArray
{
    [[@([[BHVSpec testInvocations] count]) should] beZero];
}

- (void)testNameReturnsFullNameOfCurrentExample
{
    id example = [OCMockObject mockForClass:[BHVExample class]];
    [[[example stub] andReturn:@"hello world"] fullName];
    
    BHVInvocation *invocation = [BHVInvocation emptyInvocation];
    [invocation setExample:example];
    
    BHVSpec *spec = [[BHVSpec alloc] initWithInvocation:invocation];
    [[[spec name] should] beEqualTo:@"hello world"];
}

@end
