//
//  BHVSuiteTests.m
//  Beehive
//
//  Created by Ryan Davies on 12/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVSuite.h"
#import "BHVNode.h"
#import "BHVContext.h"
#import "BHVExample.h"

@interface BHVSuiteTests : SenTestCase
@end

@implementation BHVSuiteTests

- (void)testAddsNodes
{
    BHVSuite *suite = [[BHVSuite alloc] init];
    BHVNode *node = [[BHVNode alloc] init];
    
    [suite addNode:node];
    
    [[[suite nodeAtIndex:0] should] beEqualTo:node];
}

- (void)testAddsNodesToContext
{
    BHVSuite *suite = [[BHVSuite alloc] init];
    BHVContext *context = [[BHVContext alloc] init];
    NSArray *nodes = @[[[BHVNode alloc] init], [[BHVNode alloc] init]];
    
    [suite enterContext:context];
    [suite addNode:nodes[0]];
    [suite leaveContext];
    [suite addNode:nodes[1]];
    
    [[[context nodeAtIndex:0] should] beEqualTo:nodes[0]];
    [[[suite nodeAtIndex:0] should] beEqualTo:nodes[1]];
}

- (void)testAddsNodesToNestedContext
{
    BHVSuite *suite = [[BHVSuite alloc] init];
    NSArray *contexts = @[[[BHVContext alloc] init], [[BHVContext alloc] init]];
    NSArray *nodes = @[[[BHVNode alloc] init], [[BHVNode alloc] init], [[BHVNode alloc] init]];
    
    [suite enterContext:contexts[0]];
    [suite enterContext:contexts[1]];
    [suite addNode:nodes[0]];
    [suite leaveContext];
    [suite addNode:nodes[1]];
    [suite leaveContext];
    [suite addNode:nodes[2]];
    
    [[[contexts[1] nodeAtIndex:0] should] beEqualTo:nodes[0]];
    [[[contexts[0] nodeAtIndex:0] should] beEqualTo:nodes[1]];
    [[[suite nodeAtIndex:0] should] beEqualTo:nodes[2]];
}

- (void)testReturnsExamples
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
    
    // Verify that the nodes consist only of examples, and are in order of creation:
    [[suite examples] enumerateObjectsUsingBlock:^(BHVExample *example, NSUInteger i, BOOL *stop) {
        [[example should] beEqualTo:examples[i]];
    }];
}

- (void)testReturnsNestedExamples
{
    // Build a bunch of contexts, nodes and examples in a suite:
    BHVSuite *context = [[BHVSuite alloc] init];
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
    
    // Verify that the nodes consist only of examples, and are in order of creation:
    [[context examples] enumerateObjectsUsingBlock:^(BHVExample *example, NSUInteger i, BOOL *stop) {
        [[example should] beEqualTo:examples[i]];
    }];
}

@end
