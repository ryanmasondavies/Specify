//
//  BHVExample.m
//  Beehive
//
//  Created by Ryan Davies on 27/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVExample.h"
#import "BHVContext.h"

@implementation BHVExample

- (id)copyWithZone:(NSZone *)zone
{
    BHVExample *example = [super copyWithZone:zone];
    [example setBlock:[self block]];
    [example setExecuted:[self isExecuted]];
    return example;
}

- (void)accept:(id <BHVNodeVisitor>)visitor
{
    [visitor visitExample:self];
}

- (NSString *)fullName
{
    // Work up the chain of nodes, adding them as we go:
    NSMutableArray *names = [NSMutableArray array];
    BHVNode *node = self;
    while ((node = [node context]) != nil) [names addObject:[node name]];
    
    // Reverse the names to put them in the right order:
    for (NSUInteger i = 0; i < [names count] / 2; i++)
        [names exchangeObjectAtIndex:i withObjectAtIndex:([names count] - i - 1)];
    
    // Add the name of this node:
    [names addObject:[self name]];
    
    // Concatenate with a space between each name and return:
    return [names componentsJoinedByString:@" "];
}

- (void)execute
{
    if (self.block) self.block();
    self.executed = YES;
}

@end
