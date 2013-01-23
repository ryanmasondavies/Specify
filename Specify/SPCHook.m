//
//  SPCHook.m
//  Specify
//
//  Created by Ryan Davies on 15/01/2013.
//  Copyright (c) 2013 Ryan Davies. All rights reserved.
//

#import "SPCHook.h"

@implementation SPCHook

- (BOOL)isExecutableBeforeExample:(SPCExample *)example
{
    return NO;
}

- (BOOL)isExecutableAfterExample:(SPCExample *)example
{
    return NO;
}

- (void)execute
{
    self.block();
}

@end
