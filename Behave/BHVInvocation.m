//
//  BHVInvocation.m
//  Behave
//
//  Created by Ryan Davies on 12/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVInvocation.h"
#import "BHVExample.h"

@implementation BHVInvocation

+ (id)emptyInvocation
{
    NSString *encodingType = [NSString stringWithFormat:@"%s%s%s", @encode(void), @encode(id), @encode(SEL)];
    NSMethodSignature *methodSignature = [NSMethodSignature signatureWithObjCTypes:[encodingType UTF8String]];
    return [BHVInvocation invocationWithMethodSignature:methodSignature];
}

- (void)invoke
{
    [[self example] execute];
}

@end
