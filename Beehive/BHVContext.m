//
//  BHVContext.m
//  Beehive
//
//  Created by Ryan Davies on 27/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVContext.h"
#import "BHVExampleAccumulator.h"

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

- (NSArray *)examples
{
    BHVExampleAccumulator *accumulator = [[BHVExampleAccumulator alloc] initWithNode:self];
    return [accumulator examples];
}

@end
