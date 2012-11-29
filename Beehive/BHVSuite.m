//
//  BHVSuite.m
//  Beehive
//
//  Created by Ryan Davies on 11/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVSuite.h"
#import "BHVNode.h"
#import "BHVContext.h"

@interface BHVSuite ()
@property (nonatomic, strong) NSMutableArray *nodes;
@property (nonatomic, strong) NSMutableArray *contextStack;
@end

@implementation BHVSuite

- (id)init
{
    if (self = [super init]) {
        self.nodes = [NSMutableArray array];
        self.contextStack = [NSMutableArray array];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    NSMutableArray *nodes = [NSMutableArray array];
    [[self nodes] enumerateObjectsUsingBlock:^(BHVNode *node, NSUInteger idx, BOOL *stop) {
        [nodes addObject:[node copy]];
    }];
    
    BHVSuite *suite = [super copyWithZone:zone];
    [suite setNodes:nodes];
    return suite;
}

- (void)accept:(id<BHVNodeVisitor>)visitor
{
    [[self nodes] makeObjectsPerformSelector:@selector(accept:) withObject:visitor];
}

- (void)addNode:(BHVNode *)node
{
    BHVContext *context = [[self contextStack] lastObject];
    if (context)
        [context addNode:node];
    else
        [[self nodes] addObject:node];
}

- (BHVNode *)nodeAtIndex:(NSUInteger)index
{
    return [[self nodes] objectAtIndex:index];
}

- (NSUInteger)nodeCount
{
    return [[self nodes] count];
}

- (void)enterContext:(BHVContext *)context
{
    [self.contextStack addObject:context];
}

- (void)leaveContext
{
    [self.contextStack removeLastObject];
}

@end
