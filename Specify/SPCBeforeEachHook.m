//
//  SPCBeforeEachHook.m
//  Specify
//
//  Created by Ryan Davies on 30/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "SPCBeforeEachHook.h"

@implementation SPCBeforeEachHook

- (BOOL)isExecutableBeforeExample:(SPCExample *)example
{
    return YES;
}

- (BOOL)isExecutableAfterExample:(SPCExample *)example
{
    return NO;
}

@end
