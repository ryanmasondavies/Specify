//
//  BHVContext.m
//  Beehive
//
//  Created by Ryan Davies on 21/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVContext.h"
#import "BHVExample.h"

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

- (NSArray *)compile
{
    NSMutableArray *examples = [NSMutableArray array];
    [[self items] enumerateObjectsUsingBlock:^(BHVItem *item, NSUInteger idx, BOOL *stop) {
        // Concatenate names:
        NSMutableArray *names = [NSMutableArray arrayWithObject:[self name]];
        [names addObject:[item name]];
        NSString *name = [names componentsJoinedByString:@" "];
        
        // Concatenate implementations:
        BHVImplementationBlock implementation = ^{
            [self implementation]();
            [item implementation]();
        };
        
        // Create an example with the name and implementation and add it to the list:
        BHVExample *example = [[BHVExample alloc] init];
        [example setName:name];
        [example setImplementation:implementation];
        [examples addObject:example];
    }];
    
    return [NSArray arrayWithArray:examples];
}

@end
