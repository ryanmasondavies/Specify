//
//  BHVContext.m
//  Behave
//
//  Created by Ryan Davies on 30/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVContext.h"
#import "BHVExample.h"
#import "BHVHook.h"

@implementation BHVContext

- (id)init
{
    if (self = [super init]) {
        self.contexts = [NSArray array];
        self.examples = [NSArray array];
        self.hooks    = [NSArray array];
    }
    return self;
}

- (void)addContext:(BHVContext *)context
{
    self.contexts = [[self contexts] arrayByAddingObject:context];
}

- (void)addExample:(BHVExample *)example
{
    self.examples = [[self examples] arrayByAddingObject:example];
}

- (void)addHook:(BHVHook *)hook
{
    self.hooks = [[self hooks] arrayByAddingObject:hook];
}

@end
