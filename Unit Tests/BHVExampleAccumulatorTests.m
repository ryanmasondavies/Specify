//
//  BHVExampleAccumulatorTests.m
//  Beehive
//
//  Created by Ryan Davies on 28/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVExampleAccumulator.h"
#import "BHVSuite.h"
#import "BHVContext.h"
#import "BHVExample.h"

@interface BHVExampleAccumulatorTests : SenTestCase
@end

@implementation BHVExampleAccumulatorTests

- (void)test_AccumulatesExamplesInSuite
{
    // Build a bunch of examples and nodes:
    NSMutableArray *examples = [NSMutableArray arrayWithCapacity:5];
    for (NSUInteger i = 0; i < 5; i ++) examples[i] = [BHVExample new];
    
    // Build a suite using the created examples and nodes:
    BHVSuite *suite = [[BHVSuite alloc] init];
    for (NSUInteger i = 0; i < 5; i ++) {
        [suite addNode:examples[i]];
        [suite addNode:[BHVNode new]];
    }
    
    // Accumulate examples in the suite:
    BHVExampleAccumulator *accumulator = [[BHVExampleAccumulator alloc] initWithNode:suite];
    
    // Verify that the nodes consist only of examples, and are in order of creation:
    for (NSUInteger i = 0; i < 5; i ++) [[[accumulator examples][i] should] beEqualTo:examples[i]];
}

- (void)test_AccumulatesNestedExamplesInSuite
{
    // Build a suite:
    BHVSuite *suite = [[BHVSuite alloc] init];
    
    // Keep track of examples:
    NSMutableArray *examples = [NSMutableArray array];
    
    // Define a block for simplifying context nesting:
    BHVContext * (^addContext)(id composite) = ^(id composite) {
        BHVContext *context = [[BHVContext alloc] init];
        BHVExample *example = [[BHVExample alloc] init];
        [context addNode:example];
        [context addNode:[BHVNode new]];
        [examples addObject:example];
        [composite addNode:context];
        return context;
    };
    
    // Nest three layers of contexts:
    addContext(addContext(addContext(suite)));
    
    // Accumulate examples in the suite:
    BHVExampleAccumulator *accumulator = [[BHVExampleAccumulator alloc] initWithNode:suite];
    
    // Verify that the nodes consist only of examples, and are in order of creation:
    for (NSUInteger i = 0; i < 3; i ++) [[[accumulator examples][i] should] beEqualTo:examples[i]];
}

@end
