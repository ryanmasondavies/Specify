//
//  BHVContextFunctionTests.m
//  Beehive
//
//  Created by Ryan Davies on 29/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVContextFunction.h"
#import "BHVSpec.h"
#import "BHVSuiteRegistry.h"
#import "BHVSuite.h"
#import "BHVContext.h"
#import "BHVTestHelper.h"

@interface BHVContextFunctionTests : SenTestCase
@end

@implementation BHVContextFunctionTests

- (void)testAddsNodesInContextToNewContextInCurrentSpecSuite
{
    // Set the current spec:
    [BHVSpec setCurrentSpec:[BHVTestSpec1 class]];
    
    // Add a suite for the current spec:
    BHVSuite *suite = [[BHVSuite alloc] init];
    [BHVSuiteRegistry registerSuite:suite forClass:[BHVTestSpec1 class]];
    
    // Create some nodes that will be added to the suite:
    NSMutableArray *nodes = [NSMutableArray array];
    for (NSUInteger i = 0; i < 3; i ++) nodes[i] = [[BHVNode alloc] init];
    
    // Execute the context function:
    NSString *name = @"the thing";
    void(^block)(void) = ^{
        [nodes enumerateObjectsUsingBlock:^(BHVNode *node, NSUInteger idx, BOOL *stop) {
            [suite addNode:node];
        }];
    };
    context(name, block);
    
    // Check that the nodes have been added to a new context named 'the thing' in the suite:
    BHVContext *context = (BHVContext *)[suite nodeAtIndex:0];
    [[[context name] should] beEqualTo:name];
    for (NSUInteger i = 0; i < 3; i ++) [[[context nodeAtIndex:i] should] beEqualTo:nodes[i]];
}

@end
