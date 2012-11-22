//
//  BHVSuite.h
//  Beehive
//
//  Created by Ryan Davies on 11/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

@class BHVItem;
@class BHVContext;

@interface BHVSuite : NSObject
@property (nonatomic, getter=isLocked) BOOL locked;

#pragma mark Locking

- (void)lock;
- (void)unlock;

#pragma mark Items

- (void)addItem:(BHVItem *)node;
- (BHVItem *)itemAtIndex:(NSUInteger)index;

#pragma mark Contexts

- (void)processContext:(BHVContext *)context;

#pragma mark Compilation

- (NSArray *)compile;

@end
