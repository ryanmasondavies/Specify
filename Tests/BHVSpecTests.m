//
//  BHVSpecTests.m
//  Beehive
//
//  Created by Ryan Davies on 12/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVSpec.h"
#import "BHVExample.h"
#import "BHVInvocation.h"

@interface BHVTestSpec : BHVSpec
@end

@implementation BHVTestSpec

+ (NSArray *)examples
{
    NSMutableArray *examples = [NSMutableArray array];
    
    BHVExample *example = [[BHVExample alloc] init];
    [example setDescription:@"does something"];
    [example setBlock:^{}];
    [examples addObject:example];
    
    example = [[BHVExample alloc] init];
    [example setDescription:@"does something else too"];
    [example setBlock:^{}];
    [examples addObject:example];
    
    return examples;
}

@end

@interface BHVSpecTests : SenTestCase
@end

@implementation BHVSpecTests

- (void)testReturnsInvocationsForExamples
{
    NSArray *invocations = [BHVTestSpec testInvocations];
    STAssertEqualObjects([[invocations[0] example] description], @"does something", @"First invocation was not for the first example.");
    STAssertEqualObjects([[invocations[1] example] description], @"does something else too", @"Second invocation was not for the second example.");
}

- (void)testRequestingInvocationsWhenAbstractClassReturnsEmptyArray
{
    STAssertTrue([[BHVSpec testInvocations] count] == 0, @"There should be no invocations.");
}

- (void)testNameReturnsDescriptionOfCurrentExample
{
    BHVInvocation *invocation = [BHVInvocation emptyInvocation];
    BHVExample *example = [[BHVExample alloc] init];
    [example setDescription:@"Example 1"];
    [invocation setExample:example];
    
    BHVSpec *spec = [[BHVSpec alloc] initWithInvocation:invocation];
    STAssertEquals([spec name], @"Example 1", @"Spec did not use the name of the current example.");
}

@end
