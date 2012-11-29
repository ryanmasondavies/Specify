//
//  BHVSuiteRegistry.m
//  Beehive
//
//  Created by Ryan Davies on 13/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVSuiteRegistry.h"
#import "BHVSuite.h"

@implementation BHVSuiteRegistry

+ (id)suitesByClasses
{
    static dispatch_once_t pred;
    static NSMutableDictionary *suites = nil;
    dispatch_once(&pred, ^{ suites = [[NSMutableDictionary alloc] init]; });
    return suites;
}

+ (id)suiteForClass:(Class)klass
{
    return [[self suitesByClasses] objectForKey:NSStringFromClass(klass)];
}

+ (void)registerSuite:(BHVSuite *)suite forClass:(Class)klass
{
    [[self suitesByClasses] setObject:suite forKey:NSStringFromClass(klass)];
}

+ (void)removeAllSuites
{
    [[self suitesByClasses] removeAllObjects];
}

@end
