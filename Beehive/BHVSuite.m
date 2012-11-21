//
//  BHVSuite.m
//  Beehive
//
//  Created by Ryan Davies on 11/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVSuite.h"
#import "BHVItem.h"
#import "BHVContext.h"

@interface BHVSuite ()
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) BHVContext *currentContext;
@end

@implementation BHVSuite

- (id)init
{
    if (self = [super init]) {
        self.items = [NSMutableArray array];
        [self lock];
    }
    
    return self;
}

#pragma mark Locking

- (void)lock
{
    self.locked = YES;
}

- (void)unlock
{
    self.locked = NO;
}

#pragma mark Items

- (void)addItem:(BHVItem *)item
{
    if ([self isLocked]) {
        [NSException raise:@"BHVSuiteLockException" format:@"Cannot add examples to a locked suite."];
        return;
    }
    
    if ([self currentContext])
        [[self currentContext] addItem:item];
    else
        [[self items] addObject:item];
}

- (BHVItem *)itemAtIndex:(NSUInteger)index
{
    return [[self items] objectAtIndex:index];
}

#pragma mark Context

- (void)processContext:(BHVContext *)context
{
    // Add items to the context: (see -addItem:)
    self.currentContext = context;
    context.implementation();
    self.currentContext = nil;
    
    // Add the context as an item:
    [self addItem:context];
}

#pragma mark Compilation

- (NSArray *)compiledExamples
{
    // TODO: Compile examples with their contexts.
    return [NSArray arrayWithArray:[self items]];
}

@end
