//
//  BHVContext.h
//  Beehive
//
//  Created by Ryan Davies on 27/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVNode.h"

@interface BHVContext : BHVNode
@property (nonatomic, strong) NSMutableArray *nodes;

- (void)addNode:(BHVNode *)node;
- (id)nodeAtIndex:(NSUInteger)index;

- (NSArray *)allExamples;
- (NSArray *)allHooks;

@end
