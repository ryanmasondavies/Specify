//
//  BHVExample.m
//  Beehive
//
//  Created by Ryan Davies on 27/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVExample.h"
#import "BHVContext.h"
#import "BHVHook.h"

@implementation BHVExample

- (void)accept:(id <BHVNodeVisitor>)visitor
{
    if ([visitor respondsToSelector:@selector(visitExample:)]) [visitor visitExample:self];
}

- (void)visitHook:(BHVHook *)hook
{
    [hook setExample:self];
    [hook execute];
}

- (void)execute
{
    // Locate the top-most context:
    BHVContext *topMostContext = [self context];
    while (([topMostContext context]) != nil) topMostContext = [topMostContext context];
    
    // Execute pre-execution hooks:
    [topMostContext accept:self];
    
    // Invoke block and mark as executed:
    [super execute];
    
    // Execute post-execution hooks:
    [topMostContext accept:self];
}

- (NSString *)fullName
{
    // Work up the chain of nodes, adding them as we go:
    NSMutableArray *names = [NSMutableArray array];
    BHVNode *node = self;
    while (node) {
        [names addObject:[node name]];
        node = [node context];
    }
    
    // Reverse the names to put them in the right order:
    for (NSUInteger i = 0; i < [names count] / 2; i++)
        [names exchangeObjectAtIndex:i withObjectAtIndex:([names count] - i - 1)];
    
    // Concatenate with a space between each name and return:
    return [names componentsJoinedByString:@" "];
}

@end
