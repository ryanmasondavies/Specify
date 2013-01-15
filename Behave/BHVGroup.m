//
//  BHVGroup.m
//  Behave
//
//  Created by Ryan Davies on 30/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVGroup.h"
#import "BHVExample.h"
#import "BHVHook.h"

@implementation BHVGroup

- (instancetype)init
{
    if (self = [super init]) {
        self.groups = [NSArray array];
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

- (void)addGroup:(BHVGroup *)group
{
    self.groups = [[self groups] arrayByAddingObject:group];
    [group setParentGroup:self];
}

- (void)addExample:(BHVExample *)example
{
    self.examples = [[self examples] arrayByAddingObject:example];
    [example setParentGroup:self];
}

- (void)addHook:(BHVHook *)hook
{
    self.hooks = [[self hooks] arrayByAddingObject:hook];
    [hook setParentGroup:self];
}

@end
