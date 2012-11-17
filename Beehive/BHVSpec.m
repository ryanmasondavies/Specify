//
//  BHVSpec.m
//  Beehive
//
//  Created by Ryan Davies on 11/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVSpec.h"
#import "BHVSuite.h"
#import "BHVSuiteRegistry.h"
#import "BHVExample.h"
#import "BHVInvocation.h"

@implementation BHVSpec

+ (void)initialize
{
    BHVSuite *suite = [[BHVSuite alloc] init];
    [[BHVSuiteRegistry sharedRegistry] registerSuite:suite forClass:self];
    
    BHVSpec *spec = [[[self class] alloc] init];
    [spec loadExamples];
    
    // TODO: Compile examples with their contexts.
    
    [super initialize];
}

+ (NSArray *)testInvocations
{
    BHVSuite *suite = [[BHVSuiteRegistry sharedRegistry] suiteForClass:[self class]];
    
    NSMutableArray *invocations = [NSMutableArray array];
    [[suite examples] enumerateObjectsUsingBlock:^(BHVExample *example, NSUInteger idx, BOOL *stop) {
        BHVInvocation *invocation = [BHVInvocation emptyInvocation];
        [invocation setExample:example];
        [invocations addObject:invocation];
    }];
    
    // TODO: Randomly shuffle examples.
    
    return [NSArray arrayWithArray:invocations];
}

- (void)loadExamples
{
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
