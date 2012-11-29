//
//  BHVNode.m
//  Beehive
//
//  Created by Ryan Davies on 27/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVNode.h"

@implementation BHVNode

- (id)copyWithZone:(NSZone *)zone
{
    BHVNode *node = [[[self class] allocWithZone:zone] init];
    [node setContext:[self context]];
    [node setName:[self name]];
    return node;
}

- (void)accept:(id <BHVNodeVisitor>)visitor
{
}

@end
