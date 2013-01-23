//
//  SPCGroup.m
//  Specify
//
//  Created by Ryan Davies on 30/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "SPCGroup.h"
#import "SPCExample.h"
#import "SPCHook.h"

@implementation SPCGroup

- (instancetype)init
{
    if (self = [super init]) {
        self.groups   = [NSArray array];
        self.examples = [NSArray array];
        self.hooks    = [NSArray array];
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name
{
    if (self = [self init]) {
        self.name = name;
    }
    return self;
}

- (void)addGroup:(SPCGroup *)group
{
    self.groups = [[self groups] arrayByAddingObject:group];
    [group setParentGroup:self];
}

- (void)addExample:(SPCExample *)example
{
    self.examples = [[self examples] arrayByAddingObject:example];
    [example setParentGroup:self];
}

- (void)addHook:(SPCHook *)hook
{
    self.hooks = [[self hooks] arrayByAddingObject:hook];
    [hook setParentGroup:self];
}

@end
