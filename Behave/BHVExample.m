//
//  BHVExample.m
//  Behave
//
//  Created by Ryan Davies on 30/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVExample.h"
#import "BHVGroup.h"
#import "BHVBeforeEachHook.h"

@implementation BHVExample

- (id)init
{
    if (self = [super init]) {
        self.state = BHVExampleStatePending;
    }
    return self;
}

- (void)setBlock:(void (^)(void))block
{
    _block = block;
    self.state = BHVExampleStateReady;
}

- (void)execute
{
    // Do nothing if there is no block:
    if (self.block == nil) return;
    
    // Accumulate hooks by working up the chain:
    BHVGroup *group = [self parentGroup];
    NSMutableArray *hooks  = [NSMutableArray array];
    while (group != nil) {
        // Because we're working our way out from the example, hooks must be inserted at the front of the array:
        [hooks insertObjects:[group hooks] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [[group hooks] count])]];
        
        // Move to group's parent:
        group = [group parentGroup];
    }
    
    // Execute all hooks in forward order:
    for (BHVHook *hook in [hooks objectEnumerator]) {
        if ([hook isExecutableBeforeExample:self]) {
            [hook execute];
        }
    }
    
    // Invoke example:
    self.block();
    
    // Execute all hooks in reverse order:
    for (BHVHook *hook in [hooks reverseObjectEnumerator]) {
        if ([hook isExecutableAfterExample:self]) {
            [hook execute];
        }
    }
    
    // Mark as executed:
    self.state = BHVExampleStateExecuted;
}

@end
