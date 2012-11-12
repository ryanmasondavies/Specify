//
//  BHVInvocation.m
//  Beehive
//
//  Created by Ryan Davies on 12/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVInvocation.h"
#import "BHVExample.h"

@implementation BHVInvocation

- (void)invoke
{
    [[self example] execute];
}

@end
