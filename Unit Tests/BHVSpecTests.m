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
    [suite unlock];
    [[BHVSuiteRegistry sharedRegistry] registerSuite:suite forClass:[BHVTestSpec1 class]];
    
    // Create two examples and add them to the suite:
    NSArray *names = @[@"does something", @"does something else too"];
    [names enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL *stop) {
        BHVExample *example = [[BHVExample alloc] init];
        [example setName:name];
        [example setImplementation:^{}];
        [suite addItem:example];
    }];
    
    // Retrieve the spec invocations:
    NSArray *invocations = [BHVTestSpec1 testInvocations];
    STAssertEqualObjects([[invocations[0] example] name], @"does something", @"First invocation was not for the first example.");
    STAssertEqualObjects([[invocations[1] example] name], @"does something else too", @"Second invocation was not for the second example.");
    
    // Remove the suite:
    [[BHVSuiteRegistry sharedRegistry] removeAllSuites];
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
