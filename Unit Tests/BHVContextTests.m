//
//  BHVContextTests.m
//  Beehive
//
//  Created by Ryan Davies on 30/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVContext.h"
#import "BHVHook.h"
#import "BHVExample.h"

@interface BHVContextTests : SenTestCase
@end

@implementation BHVContextTests

#pragma mark - Examples

- (void)test_AllExamples_ReturnsNestedExamples
{
    NSMutableArray *examples = [NSMutableArray array];
    for (NSUInteger i = 0; i < 17; i ++) examples[i] = [BHVExample new];
    BHVContext *context = BHVCreateBranchedStack(examples);
    
    NSMutableArray *results = [NSMutableArray array];
    NSMutableArray *expected = [NSMutableArray array];
    
    results[0] = [context allExamples];
    results[1] = [[context nodeAtIndex:1] allExamples];
    results[2] = [[context nodeAtIndex:3] allExamples];
    results[3] = [[[context nodeAtIndex:1] nodeAtIndex:1] allExamples];
    results[4] = [[[context nodeAtIndex:1] nodeAtIndex:3] allExamples];
    results[5] = [[[context nodeAtIndex:3] nodeAtIndex:1] allExamples];
    results[6] = [[[context nodeAtIndex:3] nodeAtIndex:3] allExamples];
    
    expected[0] = examples;
    expected[1] = [examples subarrayWithRange:NSMakeRange(1, 7)];
    expected[2] = [examples subarrayWithRange:NSMakeRange(9, 7)];
    expected[3] = [examples subarrayWithRange:NSMakeRange(2, 2)];
    expected[4] = [examples subarrayWithRange:NSMakeRange(5, 2)];
    expected[5] = [examples subarrayWithRange:NSMakeRange(10, 2)];
    expected[6] = [examples subarrayWithRange:NSMakeRange(13, 2)];
    
    [[results should] beEqualTo:expected];
}

#pragma mark - Hooks

- (void)test_AllHooks_ReturnsNestedExamples
{
    NSMutableArray *hooks = [NSMutableArray array];
    for (NSUInteger i = 0; i < 17; i ++) hooks[i] = [BHVHook new];
    BHVContext *context = BHVCreateBranchedStack(hooks);
    
    NSMutableArray *results = [NSMutableArray array];
    NSMutableArray *expected = [NSMutableArray array];
    
    results[0] = [context allHooks];
    results[1] = [[context nodeAtIndex:1] allHooks];
    results[2] = [[context nodeAtIndex:3] allHooks];
    results[3] = [[[context nodeAtIndex:1] nodeAtIndex:1] allHooks];
    results[4] = [[[context nodeAtIndex:1] nodeAtIndex:3] allHooks];
    results[5] = [[[context nodeAtIndex:3] nodeAtIndex:1] allHooks];
    results[6] = [[[context nodeAtIndex:3] nodeAtIndex:3] allHooks];
    
    expected[0] = hooks;
    expected[1] = [hooks subarrayWithRange:NSMakeRange(1, 7)];
    expected[2] = [hooks subarrayWithRange:NSMakeRange(9, 7)];
    expected[3] = [hooks subarrayWithRange:NSMakeRange(2, 2)];
    expected[4] = [hooks subarrayWithRange:NSMakeRange(5, 2)];
    expected[5] = [hooks subarrayWithRange:NSMakeRange(10, 2)];
    expected[6] = [hooks subarrayWithRange:NSMakeRange(13, 2)];
    
    [[results should] beEqualTo:expected];
}

@end
