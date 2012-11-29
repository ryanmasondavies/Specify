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

- (void)testReturnsInvocationsThatExecuteExamples
{
    // Create examples and add them to the suite:
    NSMutableArray *examples = [NSMutableArray array];
    for (NSUInteger i = 0; i < 10; i ++) {
        examples[i] = [[BHVExample alloc] init];
        [[BHVTestSpec1 suite] addNode:examples[i]];
    }
    
    // Invoke all test invocations:
    NSArray *invocations = [BHVTestSpec1 testInvocations];
    [invocations makeObjectsPerformSelector:@selector(invoke)];
    
    // Verify that all examples have been executed:
    [examples enumerateObjectsUsingBlock:^(BHVExample *example, NSUInteger idx, BOOL *stop) {
        [[example should] beExecuted];
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
