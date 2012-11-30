//
//  BHVDSLTests.m
//  Beehive
//
//  Created by Ryan Davies on 30/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVDSL.h"
#import "BHVSpec.h"
#import "BHVTestHelper.h"
#import "BHVSuite.h"
#import "BHVContext.h"
#import "BHVHook.h"
#import "BHVExample.h"

@interface BHVDSLTests : SenTestCase
@end

@implementation BHVDSLTests

- (void)setUp
{
    [BHVSpec setCurrentSpec:[BHVTestSpec1 class]];
}

- (void)tearDown
{
    [BHVSpec resetSuites];
}

#pragma mark It

- (void)test_It_AddsExampleToCurrentSpecSuite
{
    // Execute the it function:
    NSString *name = @"should do something";
    __block BOOL blockExecuted = NO;
    void(^block)(void) = ^{ blockExecuted = YES; };
    it(name, block);
    
    // Check that an example has been added to the suite with the name and block:
    BHVExample *example = (BHVExample *)[[BHVTestSpec1 suite] nodeAtIndex:0];
    [[[example name] should] beEqualTo:name];
    example.block(); [[@(blockExecuted) should] beTrue];
}

#pragma mark Context

- (void)test_Context_AddsNodesInContextToNewContextInCurrentSpecSuite
{
    // Create some nodes that will be added to the suite:
    NSMutableArray *nodes = [NSMutableArray array];
    for (NSUInteger i = 0; i < 3; i ++) nodes[i] = [[BHVNode alloc] init];
    
    // Execute the `context` function:
    NSString *name = @"the thing";
    void(^block)(void) = ^{
        [nodes enumerateObjectsUsingBlock:^(BHVNode *node, NSUInteger idx, BOOL *stop) {
            [[BHVTestSpec1 suite] addNode:node];
        }];
    };
    context(name, block);
    
    // Check that the nodes have been added to a new context named 'the thing' in the suite:
    BHVContext *context = (BHVContext *)[[BHVTestSpec1 suite] nodeAtIndex:0];
    [[[context name] should] beEqualTo:name];
    [nodes enumerateObjectsUsingBlock:^(BHVNode *node, NSUInteger idx, BOOL *stop) {
        [[node should] beEqualTo:nodes[idx]];
    }];
}

#pragma mark Describe

- (void)test_Describe_AddsNodesInContextToNewContextInCurrentSpecSuite
{
    // Create some nodes that will be added to the suite:
    NSMutableArray *nodes = [NSMutableArray array];
    for (NSUInteger i = 0; i < 3; i ++) nodes[i] = [[BHVNode alloc] init];
    
    // Execute the `describe` function:
    NSString *name = @"the thing";
    void(^block)(void) = ^{
        [nodes enumerateObjectsUsingBlock:^(BHVNode *node, NSUInteger idx, BOOL *stop) {
            [[BHVTestSpec1 suite] addNode:node];
        }];
    };
    describe(name, block);
    
    // Check that the nodes have been added to a new context named 'the thing' in the suite:
    BHVContext *context = (BHVContext *)[[BHVTestSpec1 suite] nodeAtIndex:0];
    [[[context name] should] beEqualTo:name];
    [nodes enumerateObjectsUsingBlock:^(BHVNode *node, NSUInteger idx, BOOL *stop) {
        [[node should] beEqualTo:nodes[idx]];
    }];
}

#pragma mark BeforeEach

- (void)test_BeforeEach_AddsHookPositioned_Before_WithFrequencyOf_Each_ToCurrentSpecSuite
{
    // Execute the `beforeEach` function:
    __block BOOL blockExecuted = NO;
    void(^block)(void) = ^{ blockExecuted = YES; };
    beforeEach(block);
    
    // Check that a before-each hook has been added to the suite:
    BHVHook *hook = (BHVHook *)[[BHVTestSpec1 suite] nodeAtIndex:0];
    [[@([hook position]) should] beEqualTo:@(BHVHookPositionBefore)];
    [[@([hook frequency]) should] beEqualTo:@(BHVHookFrequencyEach)];
    hook.block(); [[@(blockExecuted) should] beTrue];
}

#pragma mark AfterEach

- (void)test_AfterEach_AddsHookPositioned_After_WithFrequencyOf_Each_ToCurrentSpecSuite
{
    // Execute the `afterEach` function:
    __block BOOL blockExecuted = NO;
    void(^block)(void) = ^{ blockExecuted = YES; };
    afterEach(block);
    
    // Check that a hook positioned 'after' has been added to the suite:
    BHVHook *hook = (BHVHook *)[[BHVTestSpec1 suite] nodeAtIndex:0];
    [[@([hook position]) should] beEqualTo:@(BHVHookPositionAfter)];
    [[@([hook frequency]) should] beEqualTo:@(BHVHookFrequencyEach)];
    hook.block(); [[@(blockExecuted) should] beTrue];
}

#pragma mark BeforeAll

- (void)test_BeforeAll_AddsHookPositioned_Before_WithFrequencyOf_All_ToCurrentSpecSuite
{
    // Execute the `beforeAll` function:
    __block BOOL blockExecuted = NO;
    void(^block)(void) = ^{ blockExecuted = YES; };
    beforeAll(block);
    
    // Check that a before-each hook has been added to the suite:
    BHVHook *hook = (BHVHook *)[[BHVTestSpec1 suite] nodeAtIndex:0];
    [[@([hook position]) should] beEqualTo:@(BHVHookPositionBefore)];
    [[@([hook frequency]) should] beEqualTo:@(BHVHookFrequencyAll)];
    hook.block(); [[@(blockExecuted) should] beTrue];
}

#pragma mark AfterAll

- (void)test_AfterAll_AddsHookPositioned_After_WithFrequencyOf_All_ToCurrentSpecSuite
{
    // Execute the `afterAll` function:
    __block BOOL blockExecuted = NO;
    void(^block)(void) = ^{ blockExecuted = YES; };
    afterAll(block);
    
    // Check that the hook has been added to the suite:
    BHVHook *hook = (BHVHook *)[[BHVTestSpec1 suite] nodeAtIndex:0];
    [[@([hook position]) should] beEqualTo:@(BHVHookPositionAfter)];
    [[@([hook frequency]) should] beEqualTo:@(BHVHookFrequencyAll)];
    hook.block(); [[@(blockExecuted) should] beTrue];
}

@end
