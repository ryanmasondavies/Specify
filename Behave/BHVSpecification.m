//
//  BHVSpecification.m
//  Behave
//
//  Created by Ryan Davies on 30/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVSpecification.h"
#import "BHVInvocation.h"
#import "BHVBuilder.h"
#import "BHVGroup.h"
#import "BHVExample.h"

@implementation BHVSpecification

+ (void)initialize
{
    // Load examples:
    BHVSpecification *instance = [[[self class] alloc] init];
    [self setCurrentSpecification:self];
    [instance loadExamples];
    
    // Allow SenTestCase to initialize:
    [super initialize];
}

+ (void)setCurrentSpecification:(Class)specification
{
    [[[NSThread currentThread] threadDictionary] setObject:specification forKey:@"BHVCurrentSpecification"];
}

+ (Class)currentSpecification
{
    return [[[NSThread currentThread] threadDictionary] objectForKey:@"BHVCurrentSpecification"];
}

+ (NSMutableDictionary *)buildersByClass
{
    static NSMutableDictionary *buildersByClass = nil;
    if (buildersByClass == nil) buildersByClass = [NSMutableDictionary dictionary];
    return buildersByClass;
}

+ (BHVBuilder *)builder
{
    BHVBuilder *builder = [[self buildersByClass] objectForKey:NSStringFromClass(self)];
    if (builder == nil) {
        builder = [[BHVBuilder alloc] init];
        [[self buildersByClass] setObject:builder forKey:NSStringFromClass(self)];
    }
    return builder;
}

+ (NSArray *)testInvocations
{
    // Gather examples:
    NSMutableArray *examples = [NSMutableArray array];
    
    // Start at the top-most group:
    BHVGroup *topMostGroup = [[self builder] rootGroup];
    NSMutableArray *groupQueue = [NSMutableArray arrayWithObject:topMostGroup];
    
    // Pop off the first group:
    BHVGroup *currentGroup = [groupQueue objectAtIndex:0];
    [groupQueue removeObjectAtIndex:0];
    
    // Until currentGroup is nil:
    while (currentGroup) {
        // Add group's examples to list:
        [examples addObjectsFromArray:[currentGroup examples]];
        
        // Add nested groups to queue:
        [groupQueue addObjectsFromArray:[currentGroup groups]];
        
        // Move on to the next group, if there is one:
        if ([groupQueue count] > 0) {
            currentGroup = [groupQueue objectAtIndex:0];
            [groupQueue removeObjectAtIndex:0];
        } else {
            currentGroup = nil;
        }
    }
    
    // Create invocations from examples:
    NSMutableArray *invocations = [NSMutableArray array];
    [examples enumerateObjectsUsingBlock:^(BHVExample *example, NSUInteger idx, BOOL *stop) {
        [invocations addObject:[BHVInvocation invocationWithExample:example]];
    }];
    
    // Convert to immutable and return:
    return [NSArray arrayWithArray:invocations];
}

- (void)loadExamples
{
}

- (NSString *)name
{
    BHVExample *example = [(BHVInvocation *)[self invocation] example];
    return [example fullName];
}

+ (void)reset
{
    [[self buildersByClass] removeObjectForKey:NSStringFromClass(self)];
    [self initialize];
}

@end
