//
//  BHVContext.h
//  Beehive
//
//  Created by Ryan Davies on 27/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVNode.h"

@interface BHVContext : BHVNode

- (void)addNode:(BHVNode *)node;
- (BHVNode *)nodeAtIndex:(NSUInteger)index;

- (NSArray *)examples;
- (NSArray *)allExamples;

- (NSArray *)hooks;
- (NSArray *)allHooks;

@end
