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
    
    [suite setLocked:YES];
    
    NSException *exception = nil;
    @try { [suite addNode:node]; }
    @catch(NSException *e) { exception = e; };
    [[exception shouldNot] beEqualTo:nil];
}

- (void)test_WhenUnlocked_AddsNodes
{
    BHVSuite *suite = [[BHVSuite alloc] init];
    BHVNode *node = [[BHVNode alloc] init];
    
    [suite addNode:node];
    
    [[[suite nodeAtIndex:0] should] beEqualTo:node];
}

- (void)test_WhenUnlocked_AddsNodesToContext
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

- (void)test_WhenUnlocked_AddsNodesToNestedContext
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

@end
