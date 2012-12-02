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

- (void)executeHooksInContextStackFromTopToBottom
{
    // Do not execute if there is no context:
    if ([self context] == nil) return;
    
    // Locate top-most context:
    BHVContext *topMostContext = [self context];
    while (([topMostContext context]) != nil) topMostContext = [topMostContext context];
    
    // Start with the top-level context...
    NSMutableArray *contexts = [NSMutableArray arrayWithObject:topMostContext];
    while ([contexts count] > 0) {
        [[contexts[0] nodes] enumerateObjectsUsingBlock:^(id node, NSUInteger idx, BOOL *stop) {
            // Execute any hooks encountered:
            if ([node isHook]) {
                [node setExample:self];
                [node execute];
            }
            
            // Push found contexts to the stack:
            if ([node isContext]) {
                [contexts addObject:node];
            }
        }];
        
        // Pop a context off the stack:
        [contexts removeObjectAtIndex:0];
    }
}

- (void)executeHooksInContextStackFromContextToTop
{
    // Do not execute if there is no context:
    if ([self context] == nil) return;
    
    // Start with the example context:
    BHVContext *current = [self context];
    do {
        [[current nodes] enumerateObjectsUsingBlock:^(id node, NSUInteger idx, BOOL *stop) {
            if ([node isHook] == NO) return;
            [node setExample:self];
            [node execute];
        }];
        
        current = [current context];
    } while (current != nil); // Until there are no more contexts.
}

- (void)execute
{
    [self executeHooksInContextStackFromTopToBottom];
    [super execute];
    [self executeHooksInContextStackFromContextToTop];
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
