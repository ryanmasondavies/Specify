//
//  BHVInvocation.m
//  Behave
//
//  Created by Ryan Davies on 15/01/2013.
//  Copyright (c) 2013 Ryan Davies. All rights reserved.
//

#import "BHVInvocation.h"
#import "BHVExample.h"

@implementation BHVInvocation

+ (instancetype)invocationWithExample:(BHVExample *)example
{
    NSString *encodingType = [NSString stringWithFormat:@"%s%s%s", @encode(void), @encode(id), @encode(SEL)];
    NSMethodSignature *methodSignature = [NSMethodSignature signatureWithObjCTypes:[encodingType UTF8String]];
    BHVInvocation *invocation = (id)[BHVInvocation invocationWithMethodSignature:methodSignature];
    [invocation setExample:example];
    return invocation;
}

- (void)invoke
{
    [[self example] execute];
}

@end
