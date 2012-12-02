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

- (BOOL)isExample
{
    return YES;
}

- (void)execute
{
    // Gather hooks:
    BHVContext *topMostContext = [self context];
    while (([topMostContext context]) != nil) topMostContext = [topMostContext context];
    
    // Execute hooks:
    NSArray *hooks = [topMostContext hooks];
    [hooks makeObjectsPerformSelector:@selector(setExample:) withObject:self];
    [hooks makeObjectsPerformSelector:@selector(execute)];
    
    // Invoke block and mark as executed:
    [super execute];
    
    // Execute hooks in reverse:
    NSUInteger i = [hooks count];
    while (i--) [hooks[i] execute];
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
