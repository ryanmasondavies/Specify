//
//  BHVSuiteTests.m
//  Beehive
//
//  Created by Ryan Davies on 12/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVSuite.h"
#import "BHVHook.h"
#import "BHVContext.h"
#import "BHVExample.h"

@interface BHVSuiteTests : SenTestCase
@property (nonatomic, strong) NSMutableArray *examples;
@property (nonatomic, strong) NSMutableArray *hooks;
@end

@implementation BHVSuiteTests

- (void)setUp
{
    // Create a set of examples:
    self.examples = [NSMutableArray array];
    for (NSUInteger i = 0; i < 11; i ++) self.examples[i] = [BHVExample new];
    
    // Create a set of hooks:
    self.hooks = [NSMutableArray array];
    for (NSUInteger i = 0; i < 11; i ++) self.hooks[i] = [BHVHook new];
}

#pragma mark - Context stack

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

@end
