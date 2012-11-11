//
//  BHVSpec.m
//  Beehive
//
//  Created by Ryan Davies on 11/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVSpec.h"
#import "BHVExample.h"

@implementation BHVSpec

+ (NSArray *)examples
{
    return nil; // Overridden by subclasses.
}

- (void)runExampleAtIndex:(NSUInteger)index
{
    NSArray *examples = [[self class] examples];
    [examples[index] execute];
}

+ (NSArray *)testInvocations
{
    NSMutableArray *invocations = [NSMutableArray array];
    
    for (NSUInteger index = 0; index < [[self examples] count]; index ++) {
        NSMethodSignature *signature = [self instanceMethodSignatureForSelector:@selector(runExampleAtIndex:)];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setSelector:@selector(runExampleAtIndex:)];
        [invocation setArgument:&index atIndex:2];
        [invocations addObject:invocation];
    }
    
    return invocations;
}

@end
