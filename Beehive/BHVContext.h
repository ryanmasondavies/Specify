//
//  BHVContext.h
//  Beehive
//
//  Created by Ryan Davies on 21/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVItem.h"

@interface BHVContext : BHVItem

- (void)addItem:(BHVItem *)item;
- (BHVItem *)itemAtIndex:(NSUInteger)index;

- (NSArray *)compile;

@end
