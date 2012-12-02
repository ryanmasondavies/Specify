//
//  BHVContextTests.m
//  Beehive
//
//  Created by Ryan Davies on 30/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVContext.h"
#import "BHVTestHelper.h"
#import "BHVHook.h"
#import "BHVExample.h"

@interface BHVContextTests : SenTestCase
@end

@implementation BHVContextTests

#pragma mark - Examples

- (void)test_Examples_ReturnsExamples
{
    // Create a context with a bunch of examples:
    BHVContext *context = [[BHVContext alloc] init];
    NSArray *examples = examplesByAddingToContext(context, NO);
    
    // Add a bunch of nodes and hooks, to ensure that only examples are returned:
    for (NSUInteger i = 0; i < 10; i ++) {
        [context addNode:[BHVNode new]];
        [context addNode:[BHVHook new]];
    }
    
    // Verify that the context returns its examples:
    NSArray *results = [context examples];
    [[@([results count]) should] beEqualTo:@([examples count])];
    [examples enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [[obj should] beEqualTo:results[idx]];
    }];
}

- (void)test_Examples_DoesNotReturnNestedExamples
{
    // Create a stack of contexts, each with a bunch of examples:
    NSArray *contexts = stackOfContexts(3);
    NSArray *topExamples = examplesByAddingToContext(contexts[0], NO);
    examplesByAddingToContext(contexts[1], NO);
    examplesByAddingToContext(contexts[2], NO);
    
    // Add a bunch of nodes and hooks to each, to ensure that only examples are returned:
    for (NSUInteger i = 0; i < 10; i ++) {
        for (NSUInteger j = 0; j < 3; j ++) {
            [contexts[j] addNode:[BHVNode new]];
            [contexts[j] addNode:[BHVHook new]];
        }
    }
    
    // Verify that the context returns only the top examples:
    NSArray *results = [contexts[0] examples];
    [[@([results count]) should] beEqualTo:@([topExamples count])];
    [topExamples enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [[obj should] beEqualTo:results[idx]];
    }];
}

- (void)test_AllExamples_ReturnsExamples
{
    // Create a context with a bunch of examples:
    BHVContext *context = [[BHVContext alloc] init];
    NSArray *examples = examplesByAddingToContext(context, NO);
    
    // Add a bunch of nodes and hooks, to ensure that only examples are returned:
    for (NSUInteger i = 0; i < 10; i ++) {
        [context addNode:[BHVNode new]];
        [context addNode:[BHVHook new]];
    }
    
    // Verify that the context returns its examples:
    NSArray *results = [context allExamples];
    [[@([results count]) should] beEqualTo:@([examples count])];
    [examples enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [[obj should] beEqualTo:results[idx]];
    }];
}

- (void)test_AllExamples_ReturnsNestedExamples
{
    // Create a stack of contexts, each with a bunch of examples:
    NSArray *contexts = stackOfContexts(3);
    NSArray *topExamples = examplesByAddingToContext(contexts[0], NO);
    NSArray *middleExamples = examplesByAddingToContext(contexts[1], NO);
    NSArray *bottomExamples = examplesByAddingToContext(contexts[2], NO);
    
    // Add a bunch of nodes and hooks to each, to ensure that only examples are returned:
    for (NSUInteger i = 0; i < 10; i ++) {
        for (NSUInteger j = 0; j < 3; j ++) {
            [contexts[j] addNode:[BHVNode new]];
            [contexts[j] addNode:[BHVHook new]];
        }
    }
    
    // Merge the example lists for comparison:
    NSMutableArray *examples = [NSMutableArray arrayWithArray:topExamples];
    [examples addObjectsFromArray:middleExamples];
    [examples addObjectsFromArray:bottomExamples];
    
    // Verify that the context returns its examples:
    NSArray *results = [contexts[0] allExamples];
    [[@([results count]) should] beEqualTo:@([examples count])];
    [examples enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [[obj should] beEqualTo:results[idx]];
    }];
}

#pragma mark - Hooks

- (void)test_Hooks_ReturnsHooks
{
    // Create a context with a bunch of hooks:
    BHVContext *context = [[BHVContext alloc] init];
    NSArray *hooks = hooksByAddingToContext(context);
    
    // Add a bunch of nodes and examples, to ensure that only hooks are returned:
    for (NSUInteger i = 0; i < 10; i ++) {
        [context addNode:[BHVNode new]];
        [context addNode:[BHVExample new]];
    }
    
    // Verify that the context returns its hooks:
    NSArray *results = [context hooks];
    [[@([results count]) should] beEqualTo:@([hooks count])];
    [hooks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [[obj should] beEqualTo:results[idx]];
    }];
}

- (void)test_Hooks_DoesNotReturnNestedHooks
{
    // Create a stack of contexts, each with a bunch of hooks:
    NSArray *contexts = stackOfContexts(3);
    NSArray *topHooks = hooksByAddingToContext(contexts[0]);
    hooksByAddingToContext(contexts[1]);
    hooksByAddingToContext(contexts[2]);
    
    // Add a bunch of nodes and examples to each, to ensure that only hooks are returned:
    for (NSUInteger i = 0; i < 10; i ++) {
        for (NSUInteger j = 0; j < 3; j ++) {
            [contexts[j] addNode:[BHVNode new]];
            [contexts[j] addNode:[BHVExample new]];
        }
    }
    
    // Verify that the context returns only the top hooks:
    NSArray *results = [contexts[0] hooks];
    [[@([results count]) should] beEqualTo:@([topHooks count])];
    [topHooks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [[obj should] beEqualTo:results[idx]];
    }];
}

- (void)test_AllHooks_ReturnsHooks
{
    // Create a context with a bunch of hooks:
    BHVContext *context = [[BHVContext alloc] init];
    NSArray *hooks = hooksByAddingToContext(context);
    
    // Add a bunch of nodes and examples, to ensure that only hooks are returned:
    for (NSUInteger i = 0; i < 10; i ++) {
        [context addNode:[BHVNode new]];
        [context addNode:[BHVExample new]];
    }
    
    // Verify that the context returns its hooks:
    NSArray *results = [context allHooks];
    [[@([results count]) should] beEqualTo:@([hooks count])];
    [hooks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [[obj should] beEqualTo:results[idx]];
    }];
}

- (void)test_AllHooks_ReturnsNestedExamples
{
    // Create a stack of contexts, each with a bunch of hooks:
    NSArray *contexts = stackOfContexts(3);
    NSArray *topHooks = hooksByAddingToContext(contexts[0]);
    NSArray *middleHooks = hooksByAddingToContext(contexts[1]);
    NSArray *bottomHooks = hooksByAddingToContext(contexts[2]);
    
    // Add a bunch of nodes and examples to each, to ensure that only hooks are returned:
    for (NSUInteger i = 0; i < 10; i ++) {
        for (NSUInteger j = 0; j < 3; j ++) {
            [contexts[j] addNode:[BHVNode new]];
            [contexts[j] addNode:[BHVExample new]];
        }
    }
    
    // Merge the hook lists for comparison:
    NSMutableArray *hooks = [NSMutableArray arrayWithArray:topHooks];
    [hooks addObjectsFromArray:middleHooks];
    [hooks addObjectsFromArray:bottomHooks];
    
    // Verify that the context returns its hooks:
    NSArray *results = [contexts[0] allHooks];
    [[@([results count]) should] beEqualTo:@([hooks count])];
    [hooks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [[obj should] beEqualTo:results[idx]];
    }];
}

@end
