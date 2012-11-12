//
//  BHVSpec.m
//  Beehive
//
//  Created by Ryan Davies on 11/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVSpec.h"
#import "BHVExample.h"
#import "BHVSuite.h"
#import "BHVInvocation.h"

@implementation BHVSpec

+ (void)defineBehaviour
{
    // Overridden by subclasses.
}

+ (NSArray *)testInvocations
{
    SEL selector = @selector(defineBehaviour);
    if ([self methodForSelector:selector] == [BHVSpec methodForSelector:selector])
        return nil;
    
    [self defineBehaviour];
    return [[BHVSuite sharedSuite] invocations];
}

- (BHVExample *)currentExample
{
    return [(BHVInvocation *)[self invocation] example];
}

- (NSString *)name
{
    return [[self currentExample] description];
}

@end

#pragma mark Defining behaviour

void example(NSString *description, BHVVoidBlock block)
{
    BHVExample *example = [[BHVExample alloc] init];
    [example setDescription:description];
    [example setBlock:block];
    [example setDelegate:[BHVSuite sharedSuite]];
    [[BHVSuite sharedSuite] addExample:example];
}

void it(NSString *description, BHVVoidBlock block)
{
    example(description, block);
}
