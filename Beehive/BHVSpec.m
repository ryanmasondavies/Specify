//
//  BHVSpec.m
//  Beehive
//
//  Created by Ryan Davies on 11/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVSpec.h"
#import "BHVSuiteRegistry.h"
#import "BHVSuite.h"
#import "BHVInvocation.h"
#import "BHVExample.h"
#import "BHVExampleAccumulator.h"

@implementation BHVSpec

+ (void)initialize
{
    BHVSuite *suite = [[BHVSuite alloc] init];
    [BHVSuiteRegistry registerSuite:suite forClass:self];
    
    BHVSpec *spec = [[[self class] alloc] init];
    [spec loadExamples];
    [suite setLocked:YES];
    
    [super initialize];
}

+ (NSArray *)testInvocations
{
    // Grab our suite:
    BHVSuite *suite = [BHVSuiteRegistry suiteForClass:[self class]];
    
    // Collect the examples in the suite:
    BHVExampleAccumulator *accumulator = [[BHVExampleAccumulator alloc] initWithNode:suite];
    
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

- (NSString *)name
{
    return [[(BHVInvocation *)[self invocation] example] name];
}

- (void)loadExamples
{
}

@end
