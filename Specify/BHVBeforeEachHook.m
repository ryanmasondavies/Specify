//
//  BHVBeforeEachHook.m
//  Behave
//
//  Created by Ryan Davies on 30/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVBeforeEachHook.h"

@implementation BHVBeforeEachHook

- (BOOL)isExecutableBeforeExample:(BHVExample *)example
{
    return YES;
}

- (BOOL)isExecutableAfterExample:(BHVExample *)example
{
    return NO;
}

@end
