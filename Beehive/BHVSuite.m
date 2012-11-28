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
@end

@implementation BHVSuite

- (id)init
{
    if (self = [super init]) self.nodes = [NSMutableArray array];
    return self;
}

- (void)accept:(id<BHVNodeVisitor>)visitor
{
    [[self nodes] makeObjectsPerformSelector:@selector(accept:) withObject:visitor];
}

- (void)addNode:(BHVNode *)node
{
    if ([self isLocked])
        [NSException raise:@"BHVSuiteLockException" format:@"Example cannot be added when the suite is locked."];
    
    if ([self context])
        [[self context] addNode:node];
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

- (NSArray *)examples
{
    NSMutableArray *examples = [NSMutableArray array];
    [[self nodes] enumerateObjectsUsingBlock:^(BHVNode *node, NSUInteger idx, BOOL *stop) { [examples addObject:node]; }];
    return [NSArray arrayWithArray:examples];
}

@end
