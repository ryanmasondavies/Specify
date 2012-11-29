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

- (void)testCopyIsDeep
{
    BHVSuite *suite = [[BHVSuite alloc] init];
    NSArray *contexts = @[[[BHVContext alloc] init], [[BHVContext alloc] init]];
    NSArray *nodes = @[[[BHVNode alloc] init], [[BHVNode alloc] init], [[BHVNode alloc] init]];
    
    [suite addNode:nodes[0]];
    [suite addNode:contexts[0]];
    [contexts[0] addNode:nodes[1]];
    [contexts[0] addNode:contexts[1]];
    [contexts[1] addNode:nodes[2]];
    
    BHVSuite *clone = [suite copy];
    
    [[[clone nodeAtIndex:0] shouldNot] beIdenticalTo:nodes[0]];
    [[[clone nodeAtIndex:1] shouldNot] beIdenticalTo:contexts[0]];
    
    BHVContext *context = (BHVContext *)[clone nodeAtIndex:1];
    [[[context nodeAtIndex:0] shouldNot] beIdenticalTo:nodes[1]];
    [[[context nodeAtIndex:1] shouldNot] beIdenticalTo:contexts[1]];
    
    context = (BHVContext *)[context nodeAtIndex:1];
    [[[context nodeAtIndex:0] shouldNot] beIdenticalTo:nodes[2]];
}

@end
