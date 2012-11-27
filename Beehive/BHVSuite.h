//
//  BHVSuite.h
//  Beehive
//
//  Created by Ryan Davies on 11/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

@class BHVNode, BHVContext;

@protocol BHVNodeVisitor;

@interface BHVSuite : NSObject
@property (nonatomic, getter=isLocked) BOOL locked;
@property (nonatomic, strong) BHVContext *context;

- (void)addNode:(BHVNode *)node;
- (BHVNode *)nodeAtIndex:(NSUInteger)index;

- (NSArray *)examples;

@end
