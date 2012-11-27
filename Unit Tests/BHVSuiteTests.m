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

- (void)test_WhenLocked_RaisesAnException
{
    BHVSuite *suite = [[BHVSuite alloc] init];
    BHVNode *node = [[BHVNode alloc] init];
    
    STAssertThrows([suite addNode:node], @"Expected addItem: to throw an exception.");
}

- (void)test_WhenUnlocked_WithNoCurrentContext_AddsNodes
{
    BHVSuite *suite = [[BHVSuite alloc] init];
    BHVNode *node = [[BHVNode alloc] init];
    
    [suite setLocked:NO];
    [suite addNode:node];
    
    STAssertEqualObjects([suite nodeAtIndex:0], node, @"Expected addItem: to add the node to the suite.");
}

- (void)test_WhenUnlocked_AddsNodesToCurrentContext
{
    BHVSuite *suite = [[BHVSuite alloc] init];
    BHVContext *context = [[BHVContext alloc] init];
    BHVNode *node = [[BHVNode alloc] init];
    
    [suite setLocked:NO];
    [suite setContext:context];
    [suite addNode:node];
    
    STAssertEqualObjects([context nodeAtIndex:0], node, @"Expected addNode: to add the node to the context.");
}

@end
