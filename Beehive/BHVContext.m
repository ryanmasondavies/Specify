//
//  BHVContext.m
//  Beehive
//
//  Created by Ryan Davies on 27/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVContext.h"

@implementation BHVContext

- (id)init
{
    if (self = [super init]) self.nodes = [NSMutableArray array];
    return self;
}

- (BOOL)isContext
{
    return YES;
}

- (void)addNode:(BHVNode *)node
{
    [[self nodes] addObject:node];
    [node setContext:self];
}

- (id)nodeAtIndex:(NSUInteger)index
{
    return [[self nodes] objectAtIndex:index];
}

- (NSArray *)allExamples
{
    NSMutableArray *examples = [NSMutableArray array];
    [[self nodes] enumerateObjectsUsingBlock:^(BHVNode *node, NSUInteger idx, BOOL *stop) {
        if ([node isExample])
            [examples addObject:node];
        if ([node isContext])
            [examples addObjectsFromArray:[(id)node allExamples]];
    }];
    return [NSArray arrayWithArray:examples];
}

- (NSArray *)allHooks
{
    NSMutableArray *hooks = [NSMutableArray array];
    [[self nodes] enumerateObjectsUsingBlock:^(BHVNode *node, NSUInteger idx, BOOL *stop) {
        if ([node isHook])
            [hooks addObject:node];
        if ([node isContext])
            [hooks addObjectsFromArray:[(id)node allHooks]];
    }];
    return [NSArray arrayWithArray:hooks];
}

@end
