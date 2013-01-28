//
//  SPCSpecification.m
//  Specify
//
//  Created by Ryan Davies on 30/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "SPCSpecification.h"
#import "SPCInvocation.h"
#import "SPCBuilder.h"
#import "SPCGroup.h"
#import "SPCExample.h"

@implementation SPCSpecification

+ (void)initialize
{
    // Use an instance of SPCBuilder:
    [self setBuilder:[SPCBuilder new]];
    
    // Load examples:
    SPCSpecification *instance = [[[self class] alloc] init];
    [self setCurrentSpecification:self];
    [instance loadExamples];
    
    // Allow SenTestCase to initialize:
    [super initialize];
}

+ (void)setCurrentSpecification:(Class)specification
{
    [[[NSThread currentThread] threadDictionary] setObject:specification forKey:@"SPCCurrentSpecification"];
}

+ (Class)currentSpecification
{
    return [[[NSThread currentThread] threadDictionary] objectForKey:@"SPCCurrentSpecification"];
}

+ (NSArray *)testInvocations
{
    // Gather examples:
    NSMutableArray *examples = [NSMutableArray array];
    
    // Start at the top-most group:
    SPCGroup *topMostGroup = [(SPCBuilder *)[self builder] rootGroup];
    NSMutableArray *groupQueue = [NSMutableArray arrayWithObject:topMostGroup];
    
    // Pop off the first group:
    SPCGroup *currentGroup = [groupQueue objectAtIndex:0];
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
    [examples enumerateObjectsUsingBlock:^(SPCExample *example, NSUInteger idx, BOOL *stop) {
        [invocations addObject:[SPCInvocation invocationWithExample:example]];
    }];
    
    // Convert to immutable and return:
    return [NSArray arrayWithArray:invocations];
}

- (void)loadExamples
{
}

- (NSString *)name
{
    SPCExample *example = [(SPCInvocation *)[self invocation] example];
    return [example fullName];
}

+ (void)reset
{
    [self initialize];
}

@end
