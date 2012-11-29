//
//  BHVSpec.m
//  Beehive
//
//  Created by Ryan Davies on 11/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVSpec.h"
#import "BHVSuite.h"
#import "BHVInvocation.h"
#import "BHVExample.h"
#import "BHVExampleAccumulator.h"

@interface BHVSpec ()
+ (NSMutableDictionary *)suitesByClasses;
@end

@implementation BHVSpec

+ (void)initialize
{
    // Set the current spec being initialized:
    [self setCurrentSpec:self];
    
    // Load examples and lock the suite:
    BHVSpec *spec = [[[self class] alloc] init];
    [spec loadExamples];
    
    [super initialize];
}

+ (NSArray *)testInvocations
{
    // Collect the examples in the suite:
    BHVExampleAccumulator *accumulator = [[BHVExampleAccumulator alloc] initWithNode:[self suite]];
    
    // Create an invocation for each example:
    NSMutableArray *invocations = [NSMutableArray array];
    [[accumulator examples] enumerateObjectsUsingBlock:^(BHVExample *example, NSUInteger idx, BOOL *stop) {
        BHVInvocation *invocation = [BHVInvocation emptyInvocation];
        [invocation setExample:example];
        [invocations addObject:invocation];
    }];
    
    // TODO: Randomly shuffle examples.
    
    return [NSArray arrayWithArray:invocations];
}

+ (NSMutableDictionary *)suitesByClasses
{
    static dispatch_once_t pred;
    static NSMutableDictionary *suites = nil;
    dispatch_once(&pred, ^{ suites = [[NSMutableDictionary alloc] init]; });
    return suites;
}

+ (BHVSuite *)suite
{
    NSMutableDictionary *suites = [self suitesByClasses];
    BHVSuite *suite = [suites objectForKey:NSStringFromClass(self)];
    if (suite == nil) {
        suite = [[BHVSuite alloc] init];
        [suites setObject:suite forKey:NSStringFromClass(self)];
    }
    
    return suite;
}

+ (void)resetSuites
{
    [[self suitesByClasses] removeAllObjects];
}

+ (Class)currentSpec
{
    return [[NSThread currentThread] threadDictionary][@"spec"];
}

+ (void)setCurrentSpec:(Class)spec
{
    [[NSThread currentThread] threadDictionary][@"spec"] = spec;
}

- (NSString *)name
{
    return [[(BHVInvocation *)[self invocation] example] fullName];
}

- (void)loadExamples
{
}

@end
