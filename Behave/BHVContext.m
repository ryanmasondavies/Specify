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

@interface BHVContext ()
@property (strong, nonatomic) NSMutableArray *contexts;
@property (strong, nonatomic) NSMutableArray *examples;
@property (strong, nonatomic) NSMutableArray *hooks;
@end

@implementation BHVContext

- (id)init
{
    if (self = [super init]) {
        self.contexts = [NSMutableArray array];
        self.examples = [NSMutableArray array];
        self.hooks    = [NSMutableArray array];
    }
    return self;
}

- (void)addContext:(BHVContext *)context
{
    [[self contexts] addObject:context];
}

- (void)addExample:(BHVExample *)example
{
    [[self examples] addObject:example];
}

- (void)addHook:(BHVHook *)hook
{
    [[self hooks] addObject:hook];
}

@end
