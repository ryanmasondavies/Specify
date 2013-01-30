//
//  SPCBuilder.m
//  Specify
//
//  Created by Ryan Davies on 15/01/2013.
//  Copyright (c) 2013 Ryan Davies. All rights reserved.
//

#import "SPCBuilder.h"
#import "INLGroup.h"
#import "SPCExample.h"
#import "SPCHook.h"

@interface SPCBuilder ()
@property (strong, nonatomic) NSMutableArray *stack;
@end

@implementation SPCBuilder

- (id)init
{
    if (self = [super init]) {
        self.stack = [NSMutableArray arrayWithObject:[self rootGroup]];
    }
    return self;
}

- (void)enterGroup:(INLGroup *)group
{
    [[self stack] addObject:group];
}

- (void)leaveGroup
{
    // Pop a group from the group stack:
    INLGroup *group = [[self stack] lastObject];
    [[self stack] removeLastObject];
    
    // Add the popped group to what is now the top group:
    [[[self stack] lastObject] addGroup:group];
}

- (void)addExample:(SPCExample *)example
{
    INLGroup *group = [[self stack] lastObject];
    [group addTest:example];
}

- (void)addHook:(SPCHook *)hook
{
    INLGroup *group = [[self stack] lastObject];
    [group addHook:hook];
}

@end
