//
//  BHVExample.m
//  Behave
//
//  Created by Ryan Davies on 30/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVExample.h"
#import "BHVContext.h"
#import "BHVBeforeEachHook.h"

@implementation BHVExample

- (instancetype)initWithName:(NSString *)name block:(void(^)(void))block
{
    if (self = [self init]) {
        self.name = name;
        self.block = block;
    }
    return self;
}

- (void)execute
{
    // Do nothing if there is no block:
    if (self.block == nil) return;
    
    // Accumulate hooks by working up the chain:
    BHVContext *context = [self parentContext];
    NSMutableArray *hooks  = [NSMutableArray array];
    while (context != nil) {
        // Because we're working our way out from the example, hooks must be inserted at the front of the array:
        [hooks insertObjects:[context hooks] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [[context hooks] count])]];
        
        // Move to context's parent:
        context = [context parentContext];
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
    self.executed = YES;
}

@end
