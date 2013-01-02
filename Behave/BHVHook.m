//
//  BHVHook.m
//  Behave
//
//  Created by Ryan Davies on 30/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVHook.h"

@implementation BHVHook

- (instancetype)initWithFlavor:(BHVHookFlavor)flavor
{
    if (self = [super init]) {
        self.flavor = flavor;
    }
    return self;
}

@end
