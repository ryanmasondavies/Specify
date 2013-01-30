//
//  SPCSpecification.m
//  Specify
//
//  Created by Ryan Davies on 30/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "SPCSpecification.h"
#import "SPCBuilder.h"
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

+ (NSArray *)blacklistedClasses
{
    return [[super blacklistedClasses] arrayByAddingObject:self];
}

- (void)loadExamples
{
}

@end
