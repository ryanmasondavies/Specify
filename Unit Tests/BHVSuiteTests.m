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

- (void)test_WhenUnlocked_WithNoCurrentContext_AddsNodes
{
    BHVSuite *suite = [[BHVSuite alloc] init];
    BHVNode *node = [[BHVNode alloc] init];
    
    [suite addNode:node];
    
    [[[suite nodeAtIndex:0] should] beEqualTo:node];
}

- (void)test_WhenUnlocked_AddsNodesToCurrentContext
{
    BHVSuite *suite = [[BHVSuite alloc] init];
    BHVContext *context = [[BHVContext alloc] init];
    BHVNode *node = [[BHVNode alloc] init];
    
    [suite setContext:context];
    [suite addNode:node];
    
    [[[context nodeAtIndex:0] should] beEqualTo:node];
}

@end
