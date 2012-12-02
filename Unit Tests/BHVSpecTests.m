//
//  BHVSpecTests.m
//  Beehive
//
//  Created by Ryan Davies on 12/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVSpec.h"
#import "BHVTestHelper.h"
#import "BHVSuite.h"
#import "BHVExample.h"
#import "BHVInvocation.h"

Class recordedSpec = nil;

@interface PSTBeMatcher ()
- (BOOL)beExecuted;
@end

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

- (void)testSuiteIsSpecificForEachSubclass
{
    BHVSuite *firstSuite = [BHVTestSpec1 suite];
    BHVSuite *secondSuite = [BHVTestSpec2 suite];
    
    [[firstSuite shouldNot] beIdenticalTo:secondSuite];
    
    [BHVSpec resetSuites];
}

- (void)testReturnsInvocationsForExamplesInForwardOrder
{
    // Create a stack of contexts, each with a bunch of examples:
    NSArray *contexts = stackOfContexts(10);
    NSMutableArray *examples = [NSMutableArray array];
    for (NSUInteger i = 0; i < 10; i ++) [examples addObjectsFromArray:examplesByAddingToContext(contexts[i], NO)];
    
    // Add top context to the suite:
    [[BHVTestSpec1 suite] addNode:contexts[0]];
    
    // Retrieve test invocations:
    NSArray *invocations = [BHVTestSpec1 testInvocations];
    
    // Verify that there are 100 invocations:
    [[@([invocations count]) should] beEqualTo:@100];
    
    // Verify that invocation examples are in forward order:
    [invocations enumerateObjectsUsingBlock:^(BHVInvocation *invocation, NSUInteger idx, BOOL *stop) {
        [[[invocation example] should] beIdenticalTo:examples[idx]];
    }];
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
