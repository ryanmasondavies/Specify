//
//  BHVNode.m
//  Beehive
//
//  Created by Ryan Davies on 27/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVNode.h"

@implementation BHVNode

- (NSString *)name
{
    if (_name) return _name;
    return @""; // Never return nil.
}

- (BOOL)isContext
{
    return NO;
}

- (BOOL)isExample
{
    return NO;
}

- (BOOL)isHook
{
    return NO;
}

- (void)accept:(id <BHVNodeVisitor>)visitor
{
}

@end
