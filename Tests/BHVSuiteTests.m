//
//  BHVSuiteTests.m
//  Beehive
//
//  Created by Ryan Davies on 12/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVSuite.h"
#import "BHVExample.h"
#import "BHVInvocation.h"

@interface BHVSuiteTests : SenTestCase; @end

@implementation BHVSuiteTests

- (void)tearDown
{
    [[BHVSuite sharedSuite] removeAllExamples];
}

- (void)testSharedSuiteReturnsSameInstance
{
    id firstCall = [BHVSuite sharedSuite];
    id secondCall = [BHVSuite sharedSuite];
    
    STAssertTrue([firstCall isKindOfClass:[BHVSuite class]], @"First retrieval of the shared suite did not return an instance of BHVSuite.");
    STAssertTrue([secondCall isKindOfClass:[BHVSuite class]], @"Second retrieval of the shared suite did not return an instance of BHVSuite.");
    STAssertTrue(firstCall == secondCall, @"sharedSuite did not consistently return the same instance.");
}

- (void)testCreatesInvocationsForEachExample
{
    NSArray *examples = @[[BHVExample new], [BHVExample new], [BHVExample new]];
    BHVSuite *suite = [[BHVSuite alloc] init];
    
    [suite addExample:examples[0]];
    [suite addExample:examples[1]];
    [suite addExample:examples[2]];
    
    NSArray *invocations = [suite invocations];
    
    STAssertEqualObjects([invocations[0] example], examples[0], @"First invocation was not for the first example.");
    STAssertEqualObjects([invocations[1] example], examples[1], @"Second invocation was not for the second example.");
    STAssertEqualObjects([invocations[2] example], examples[2], @"Third invocation was not for the third example.");
}

- (void)testExampleFunctionAddsExampleToSharedSuite
{
    NSString *description = @"example description";
    BHVVoidBlock block = ^{};
    
    example(description, block);
    
    BHVExample *example = [[BHVSuite sharedSuite] exampleAtIndex:0];
    STAssertEquals([example description], description, @"example() did not add an example with the description provided to it.");
    STAssertEquals([example block], block, @"example() did not add an example with the block provided to it.");
}

- (void)testItFunctionAddsExampleToSharedSuite
{
    NSString *description = @"example description";
    BHVVoidBlock block = ^{};
    
    it(description, block);
    
    BHVExample *example = [[BHVSuite sharedSuite] exampleAtIndex:0];
    STAssertEquals([example description], description, @"it() did not add an example with the description provided to it.");
    STAssertEquals([example block], block, @"it() did not add an example with the block provided to it.");
}

@end
