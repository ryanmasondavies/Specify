//
//  BHVContext.m
//  Beehive
//
//  Created by Ryan Davies on 21/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVContext.h"

@interface BHVContext ()
@property (nonatomic, strong) NSMutableArray *items;
@end

@implementation BHVContext

- (id)init
{
    if (self = [super init]) {
        self.items = [NSMutableArray array];
    }
    
    return self;
}

- (void)addItem:(BHVItem *)item
{
    [[self items] addObject:item];
}

- (BHVItem *)itemAtIndex:(NSUInteger)index
{
    return [[self items] objectAtIndex:index];
}

@end
