//
//  BHVBuilder.m
//  Behave
//
//  Created by Ryan Davies on 15/01/2013.
//  Copyright (c) 2013 Ryan Davies. All rights reserved.
//

#import "BHVBuilder.h"
#import "BHVGroup.h"
#import "BHVExample.h"
#import "BHVHook.h"

@interface BHVBuilder ()
@property (strong, nonatomic) NSMutableArray *stack;
@end

@implementation BHVBuilder

- (id)init
{
    if (self = [super init]) {
        self.stack = [NSMutableArray arrayWithObject:[BHVGroup new]];
    }
    return self;
}

- (BHVGroup *)rootGroup
{
    return [[self stack] objectAtIndex:0];
}

- (void)enterGroup:(BHVGroup *)group
{
    [[self stack] addObject:group];
}

- (void)leaveGroup
{
    // Pop a group from the group stack:
    BHVGroup *group = [[self stack] lastObject];
    [[self stack] removeLastObject];
    
    // Add the popped group to what is now the top group:
    [[[self stack] lastObject] addGroup:group];
}

- (void)addExample:(BHVExample *)example
{
    [[[self stack] lastObject] addExample:example];
}

- (void)addHook:(BHVHook *)hook
{
    [[[self stack] lastObject] addHook:hook];
}

@end
