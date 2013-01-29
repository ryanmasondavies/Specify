//
//  SPCExample.m
//  Specify
//
//  Created by Ryan Davies on 30/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "SPCExample.h"
#import "INLGroup.h"

@implementation SPCExample

- (id)init
{
    if (self = [super init]) {
        self.state = SPCExampleStatePending;
    }
    return self;
}

- (void)setBlock:(void (^)(void))block
{
    _block = block;
    self.state = SPCExampleStateReady;
}

- (void)execute
{
    if (self.block == nil) return;
    [self executeBeforeHooks];
    self.block();
    [self executeAfterHooks];
    self.state = SPCExampleStateExecuted;
}

- (NSString *)fullName
{
    NSMutableArray *labels = [NSMutableArray array];
    INLGroup *group = [self parent];
    while (group != nil) {
        if ([group label]) [labels insertObject:[group label] atIndex:0];
        group = [group parent];
    }
    [labels addObject:[self label]];
    return [labels componentsJoinedByString:@" "];
}

@end
