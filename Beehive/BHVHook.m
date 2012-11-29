//
//  BHVHook.m
//  Beehive
//
//  Created by Ryan Davies on 29/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVHook.h"

@implementation BHVHook

- (void)accept:(id<BHVNodeVisitor>)visitor
{
    [visitor visitHook:self];
}

- (void)execute
{
    if ([self block])
        self.block();
    
    self.executed = YES;
}

@end
