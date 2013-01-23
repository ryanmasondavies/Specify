//
//  SPCBuilder.m
//  Specify
//
//  Created by Ryan Davies on 15/01/2013.
//  Copyright (c) 2013 Ryan Davies. All rights reserved.
//

#import "SPCBuilder.h"
#import "SPCGroup.h"
#import "SPCExample.h"
#import "SPCHook.h"

@interface SPCBuilder ()
@property (strong, nonatomic) NSMutableArray *stack;
@end

@implementation SPCBuilder

- (id)init
{
    if (self = [super init]) {
        self.stack = [NSMutableArray arrayWithObject:[SPCGroup new]];
    }
    return self;
}

- (SPCGroup *)rootGroup
{
    return [[self stack] objectAtIndex:0];
}

- (void)enterGroup:(SPCGroup *)group
{
    [[self stack] addObject:group];
}

- (void)leaveGroup
{
    // Pop a group from the group stack:
    SPCGroup *group = [[self stack] lastObject];
    [[self stack] removeLastObject];
    
    // Add the popped group to what is now the top group:
    [[[self stack] lastObject] addGroup:group];
}

- (void)addExample:(SPCExample *)example
{
    [[[self stack] lastObject] addExample:example];
}

- (void)addHook:(SPCHook *)hook
{
    [[[self stack] lastObject] addHook:hook];
}

@end
