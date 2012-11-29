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

- (void)addNode:(BHVNode *)node;
- (BHVNode *)nodeAtIndex:(NSUInteger)index;
- (NSUInteger)nodeCount;

- (void)enterContext:(BHVContext *)context;
- (void)leaveContext;

@end
