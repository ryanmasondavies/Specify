//
//  BHVTestHelper.m
//  Beehive
//
//  Created by Ryan Davies on 21/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVTestHelper.h"
#import "BHVContext.h"
#import "BHVExample.h"
#import "BHVHook.h"

Class recordedSpec = nil;

NSArray * stackOfContexts(NSUInteger count)
{
    NSMutableArray *contexts = [NSMutableArray array];
    for (NSUInteger i = 0; i < count; i ++) {
        contexts[i] = [[BHVContext alloc] init];
        if (i > 0) [contexts[i-1] addNode:contexts[i]];
    }
    return contexts;
}

NSArray * examplesByAddingToContext(BHVContext *context, NSUInteger number, BOOL markAsExecuted)
{
    NSMutableArray *examples = [NSMutableArray array];
    for (NSUInteger i = 0; i < number; i ++) {
        examples[i] = [[BHVExample alloc] init];
        [examples[i] setExecuted:markAsExecuted];
        [context addNode:examples[i]];
    }
    return examples;
};

NSArray * hooksByAddingToContext(BHVContext *context, NSUInteger number)
{
    NSMutableArray *hooks = [NSMutableArray array];
    for (NSUInteger i = 0; i < number; i ++) {
        hooks[i] = [[BHVHook alloc] init];
        [context addNode:hooks[i]];
    }
    return hooks;
}

BHVContext * BHVCreateBranchedStack(NSArray *nodes)
{
    /*
     * Create a stack in the following format, where the numbers are the node indexes:
     *
     *----------------------------------------------------------*
     *                                                          *
     *                        +-------+                         *
     *                 0 <---+|CONTEXT|+---> 16                 *
     *                        +-------+                         *
     *                          + + +                           *
     *              +-----------+ | +-----------+               *
     *              v             v             v               *
     *          +-------+         8         +-------+           *
     *  1<---+-+|CONTEXT|+-+--->7   9<---+-+|CONTEXT|+-+--->15  *
     *       |  +-------+  |             |  +-------+  |        *
     *       |      +      |             |      +      |        *
     *       v      v      v             v      v      v        *
     *   +-------+  4  +-------+     +-------+ 12  +-------+    *
     *   |CONTEXT|     |CONTEXT|     |CONTEXT|     |CONTEXT|    *
     *   +-------+     +-------+     +-------+     +-------+    *
     *     +   +         +   +         +   +         +   +      *
     *     |   |         |   |         |   |         |   |      *
     *     |   |         |   |         |   |         |   |      *
     *     v   v         v   v         v   v         v   v      *
     *     2   3         5   6        10  11        13  14      *
     *                                                          *
     *----------------------------------------------------------*
     *
     * A total of 17 nodes are needed to build the stack.
     *
     */
    
    BHVContext *context = [[BHVContext alloc] init];
    
    [context addNode:nodes[0]];
    [context addNode:[BHVContext new]];
    [[context nodeAtIndex:1] addNode:nodes[1]];
    [[context nodeAtIndex:1] addNode:[BHVContext new]];
    [[[context nodeAtIndex:1] nodeAtIndex:1] addNode:nodes[2]];
    [[[context nodeAtIndex:1] nodeAtIndex:1] addNode:nodes[3]];
    [[context nodeAtIndex:1] addNode:nodes[4]];
    [[context nodeAtIndex:1] addNode:[BHVContext new]];
    [[[context nodeAtIndex:1] nodeAtIndex:3] addNode:nodes[5]];
    [[[context nodeAtIndex:1] nodeAtIndex:3] addNode:nodes[6]];
    [[context nodeAtIndex:1] addNode:nodes[7]];
    [context addNode:nodes[8]];
    [context addNode:[BHVContext new]];
    [[context nodeAtIndex:3] addNode:nodes[9]];
    [[context nodeAtIndex:3] addNode:[BHVContext new]];
    [[[context nodeAtIndex:3] nodeAtIndex:1] addNode:nodes[10]];
    [[[context nodeAtIndex:3] nodeAtIndex:1] addNode:nodes[11]];
    [[context nodeAtIndex:3] addNode:nodes[12]];
    [[context nodeAtIndex:3] addNode:[BHVContext new]];
    [[[context nodeAtIndex:3] nodeAtIndex:3] addNode:nodes[13]];
    [[[context nodeAtIndex:3] nodeAtIndex:3] addNode:nodes[14]];
    [[context nodeAtIndex:3] addNode:nodes[15]];
    [context addNode:nodes[16]];
    
    return context;
}

@implementation BHVTestSpec1
@end

@implementation BHVTestSpec2
@end

@implementation BHVTestSpec3
@end

@implementation BHVCurrentSpecRecorderSpec

- (void)loadExamples
{
    recordedSpec = [BHVSpec currentSpec];
}

@end
