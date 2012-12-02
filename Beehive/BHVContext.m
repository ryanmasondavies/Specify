//
//  BHVContext.m
//  Beehive
//
//  Created by Ryan Davies on 27/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVContext.h"

@interface BHVContext ()
@property (nonatomic, strong) NSMutableArray *nodes;
@end

@implementation BHVContext

- (id)init
{
    self = [super init];
    if (self) {
        self.nodes = [NSMutableArray array];
    }
    
    return self;
}

- (BOOL)isContext
{
    return YES;
}

- (void)accept:(id <BHVNodeVisitor>)visitor
{
    [[self nodes] makeObjectsPerformSelector:@selector(accept:) withObject:visitor];
}

- (void)addNode:(BHVNode *)node
{
    [[self nodes] addObject:node];
    [node setContext:self];
}

- (BHVNode *)nodeAtIndex:(NSUInteger)index
{
    return [[self nodes] objectAtIndex:index];
}

- (NSArray *)contexts
{
    NSMutableArray *contexts = [NSMutableArray array];
    [[self nodes] enumerateObjectsUsingBlock:^(BHVNode *node, NSUInteger idx, BOOL *stop) {
        if ([node isContext]) [contexts addObject:node];
    }];
    
    return [NSArray arrayWithArray:contexts];
}

- (NSArray *)examples
{
    NSMutableArray *examples = [NSMutableArray array];
    [[self nodes] enumerateObjectsUsingBlock:^(BHVNode *node, NSUInteger idx, BOOL *stop) {
        if ([node isExample]) [examples addObject:node];
    }];
    
    return [NSArray arrayWithArray:examples];
}

- (NSArray *)hooks
{
    NSMutableArray *examples = [NSMutableArray array];
    [[self nodes] enumerateObjectsUsingBlock:^(BHVNode *node, NSUInteger idx, BOOL *stop) {
        if ([node isHook]) [examples addObject:node];
    }];
    
    return [NSArray arrayWithArray:examples];
}

- (NSArray *)allExamples
{
    NSMutableArray *examples = [NSMutableArray arrayWithArray:[self examples]];
    [[self contexts] enumerateObjectsUsingBlock:^(BHVContext *context, NSUInteger idx, BOOL *stop) {
        [examples addObjectsFromArray:[context allExamples]];
    }];
    return [NSArray arrayWithArray:examples];
}

- (NSArray *)allHooks
{
    NSMutableArray *hooks = [NSMutableArray arrayWithArray:[self hooks]];
    [[self contexts] enumerateObjectsUsingBlock:^(BHVContext *context, NSUInteger idx, BOOL *stop) {
        [hooks addObjectsFromArray:[context allHooks]];
    }];
    return [NSArray arrayWithArray:hooks];
}

@end
