//
//  BHVSpecTests.m
//  Beehive
//
//  Created by Ryan Davies on 12/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVSpec.h"
#import "BHVSuite.h"
#import "BHVExample.h"
#import "BHVInvocation.h"

BOOL behaviourDefined = NO;

@interface BHVTestSpec : BHVSpec; @end
@implementation BHVTestSpec

+ (void)defineBehaviour
{
    behaviourDefined = YES;
}

@end

@interface BHVSpecTests : SenTestCase; @end
@implementation BHVSpecTests

- (NSArray *)addSomeExamplesToSharedSuite
{
    NSArray *examples = @[[BHVExample new], [BHVExample new], [BHVExample new]];
    BHVSuite *suite = [BHVSuite sharedSuite];
    [examples enumerateObjectsUsingBlock:^(id example, NSUInteger idx, BOOL *stop) {
        [suite addExample:example];
    }];
    return examples;
}

- (void)testRequestingInvocationsDefinesBehaviour
{
    behaviourDefined = NO;
    [BHVTestSpec testInvocations];
    STAssertTrue(behaviourDefined, @"Behaviour was not marked as defined.");
}

- (void)testRequestingInvocationsReturnsInvocationsForExamples
{
    NSArray *examples = [self addSomeExamplesToSharedSuite];
    NSArray *invocations = [BHVTestSpec testInvocations];
    STAssertEqualObjects([invocations[0] example], examples[0], @"First invocation was not for the first example.");
    STAssertEqualObjects([invocations[1] example], examples[1], @"Second invocation was not for the second example.");
    STAssertEqualObjects([invocations[2] example], examples[2], @"Third invocation was not for the third example.");
}

- (void)testRequestingInvocationsWhenAbstractClassReturnsEmptyArray
{
    [self addSomeExamplesToSharedSuite];
    STAssertTrue([[BHVSpec testInvocations] count] == 0, @"There should be no invocations.");
}

- (void)testNameIsDescriptionOfCurrentExample
{
    BHVInvocation *invocation = [BHVInvocation emptyInvocation];
    BHVExample *example = [[BHVExample alloc] init];
    [example setDescription:@"Example 1"];
    [invocation setExample:example];
    
    BHVSpec *spec = [[BHVSpec alloc] initWithInvocation:invocation];
    STAssertEquals([spec name], @"Example 1", @"Spec did not use the name of the current example.");
}

@end
