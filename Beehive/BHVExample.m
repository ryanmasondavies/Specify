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
    [visitor visitExample:self];
}

- (void)visitHook:(BHVHook *)hook
{
    [hook execute];
}

- (void)visitExample:(BHVExample *)example
{
}

- (NSString *)fullName
{
    // Work up the chain of nodes, adding them as we go:
    NSMutableArray *names = [NSMutableArray array];
    BHVNode *node = self;
    while (node) {
        if ([node name])
            [names addObject:[node name]];
        node = [node context];
    }
    
    // Reverse the names to put them in the right order:
    for (NSUInteger i = 0; i < [names count] / 2; i++)
        [names exchangeObjectAtIndex:i withObjectAtIndex:([names count] - i - 1)];
    
    // Concatenate with a space between each name and return:
    return [names componentsJoinedByString:@" "];
}

- (void)execute
{
    // Locate the top-most context:
    BHVContext *topMostContext = [self context];
    while (([topMostContext context]) != nil) topMostContext = [topMostContext context];
    
    // Visit the top-most context, allowing the example to execute all hooks:
    [topMostContext accept:self];
    
    // Invoke block and mark as executed:
    if (self.block) self.block();
    self.executed = YES;
}

@end
