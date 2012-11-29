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

- (void)testReturnsInvocationsForCompiledExamples
{
    // Create two examples and add them to the suite:
    NSMutableArray *examples = [NSMutableArray array];
    for (NSUInteger i = 0; i < 3; i ++) {
        examples[i] = [[BHVExample alloc] init];
        [[BHVTestSpec1 suite] addNode:examples[i]];
    }
    
    // Retrieve the spec invocations:
    NSArray *invocations = [BHVTestSpec1 testInvocations];
    for (NSUInteger i = 0; i < 3; i ++) [[[invocations[i] example] should] beEqualTo:examples[i]];
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
