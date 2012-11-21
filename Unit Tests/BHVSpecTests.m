//
//  BHVSpecTests.m
//  Beehive
//
//  Created by Ryan Davies on 12/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVSpec.h"
#import "BHVSuiteRegistry.h"
#import "BHVSuite.h"
#import "BHVExample.h"
#import "BHVInvocation.h"

@interface BHVTestSpec : BHVSpec
@end

@implementation BHVTestSpec

- (void)loadExamples
{
    BHVSuite *suite = [[BHVSuiteRegistry sharedRegistry] suiteForClass:[self class]];
    
    BHVExample *example = [[BHVExample alloc] init];
    [example setName:@"does something"];
    [example setImplementation:^{}];
    [suite addItem:example];
    
    example = [[BHVExample alloc] init];
    [example setName:@"does something else too"];
    [example setImplementation:^{}];
    [suite addItem:example];
}

@end

@interface BHVSpecTests : SenTestCase
@end

@implementation BHVSpecTests

- (void)testReturnsInvocationsForExamples
{
    NSArray *invocations = [BHVTestSpec testInvocations];
    STAssertEqualObjects([[invocations[0] example] name], @"does something", @"First invocation was not for the first example.");
    STAssertEqualObjects([[invocations[1] example] name], @"does something else too", @"Second invocation was not for the second example.");
}

- (void)testRequestingInvocationsWhenAbstractClassReturnsEmptyArray
{
    STAssertTrue([[BHVSpec testInvocations] count] == 0, @"There should be no invocations.");
}

- (void)testNameReturnsNameOfCurrentExample
{
    BHVInvocation *invocation = [BHVInvocation emptyInvocation];
    BHVExample *example = [[BHVExample alloc] init];
    [example setName:@"Example 1"];
    [invocation setExample:example];
    
    BHVSpec *spec = [[BHVSpec alloc] initWithInvocation:invocation];
    STAssertEquals([spec name], @"Example 1", @"Spec did not use the name of the current example.");
}

@end
