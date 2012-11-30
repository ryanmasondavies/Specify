//
//  BHVHook.m
//  Beehive
//
//  Created by Ryan Davies on 29/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVHook.h"
#import "BHVExample.h"

@implementation BHVHook

- (void)accept:(id<BHVNodeVisitor>)visitor
{
    [visitor visitHook:self];
}

- (void)execute
{
    if ([self position] == BHVHookPositionBefore && [[self example] isExecuted]) return;
    if ([self position] == BHVHookPositionAfter && [[self example] isExecuted] == NO) return;
    [super execute];
}

@end
