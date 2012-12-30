//
//  BHVSpecTests.m
//  Behave
//
//  Created by Ryan Davies on 12/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVSpec.h"
#import "BHVSuite.h"
#import "BHVExample.h"
#import "BHVHook.h"
#import "BHVInvocation.h"

@interface PSTBeMatcher ()
- (BOOL)beExecuted;
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

- (void)testSuiteIsSpecificForEachSubclass
{
    BHVSuite *firstSuite = [BHVTestSpec1 suite];
    BHVSuite *secondSuite = [BHVTestSpec2 suite];
    
    [[firstSuite shouldNot] beIdenticalTo:secondSuite];
    
    [BHVSpec resetSuites];
}

- (void)testReturnsInvocationsForExamplesInOrderOfDeepestToShallowest
{
    // Create a set of examples:
    NSMutableArray *examples = [NSMutableArray array];
    for (NSUInteger i = 0; i < 17; i ++) examples[i] = [BHVExample new];
    
    // Branch the examples over a stack of contexts:
    BHVContext *context = BHVCreateBranchedStack(examples);
    
    // Add root context to the suite:
    [[BHVTestSpec1 suite] addNode:context];
    
    // Retrieve examples from all invocations:
    NSArray *invocations = [BHVTestSpec1 testInvocations];
    NSMutableArray *invocationExamples = [NSMutableArray array];
    [invocations enumerateObjectsUsingBlock:^(BHVInvocation *invocation, NSUInteger idx, BOOL *stop) {
        [invocationExamples addObject:[invocation example]];
    }];
    
    // Verify that the invocations are for every example:
    [[invocationExamples should] beEqualTo:examples];
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
