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

- (void)addNode:(BHVNode *)node
{
    [[self nodes] addObject:node];
}

- (BHVNode *)nodeAtIndex:(NSUInteger)index
{
    return [[self nodes] objectAtIndex:index];
}

@end
