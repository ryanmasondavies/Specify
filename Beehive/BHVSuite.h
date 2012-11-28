//
//  BHVSuite.h
//  Beehive
//
//  Created by Ryan Davies on 11/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVNode.h"

@class BHVNode, BHVContext;

@interface BHVSuite : BHVNode
@property (nonatomic, getter=isLocked) BOOL locked;
@property (nonatomic, strong) BHVContext *context;

- (void)addNode:(BHVNode *)node;
- (BHVNode *)nodeAtIndex:(NSUInteger)index;
- (NSUInteger)nodeCount;

@end
