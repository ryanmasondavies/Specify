//
//  BHVAfterEachHook.m
//  Behave
//
//  Created by Ryan Davies on 15/01/2013.
//  Copyright (c) 2013 Ryan Davies. All rights reserved.
//

#import "BHVAfterEachHook.h"

@implementation BHVAfterEachHook

- (BOOL)isExecutableBeforeExample:(BHVExample *)example
{
    return NO;
}

- (BOOL)isExecutableAfterExample:(BHVExample *)example
{
    return YES;
}

@end
