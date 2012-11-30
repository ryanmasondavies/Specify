//
//  BHVContextTests.m
//  Beehive
//
//  Created by Ryan Davies on 30/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVContext.h"
#import "BHVExample.h"

@interface BHVContextTests : SenTestCase
@end

@implementation BHVContextTests

- (void)testReturnsExamples
{
    // Build a bunch of examples and nodes:
    NSMutableArray *examples = [NSMutableArray arrayWithCapacity:5];
    for (NSUInteger i = 0; i < 5; i ++) examples[i] = [BHVExample new];
    
    // Build a suite using the created examples and nodes:
    BHVContext *context = [[BHVContext alloc] init];
    for (NSUInteger i = 0; i < 5; i ++) {
        [context addNode:examples[i]];
        [context addNode:[BHVNode new]];
    }
    
    // Accumulate examples in the suite:
    NSArray *results = [context examples];
    
    // Verify that the nodes consist only of examples, and are in order of creation:
    for (NSUInteger i = 0; i < 5; i ++) [[results[i] should] beEqualTo:examples[i]];
}

- (void)testReturnsNestedExamples
{
    // Build a bunch of contexts, nodes and examples in a context:
    BHVContext *context = [[BHVContext alloc] init];
    NSMutableArray *examples = [NSMutableArray array];
    BHVContext *(^addContext)(id composite) = ^(id composite) {
        BHVContext *context = [[BHVContext alloc] init];
        BHVExample *example = [[BHVExample alloc] init];
        [context addNode:example];
        [context addNode:[BHVNode new]];
        [examples addObject:example];
        [composite addNode:context];
        return context;
    };
    addContext(addContext(addContext(context)));
    
    // Accumulate examples in the suite:
    NSArray *results = [context examples];
    
    // Verify that the nodes consist only of examples, and are in order of creation:
    [results enumerateObjectsUsingBlock:^(BHVExample *example, NSUInteger i, BOOL *stop) {
        [[example should] beEqualTo:examples[i]];
    }];
}

@end
