//
//  BHVHook.m
//  Beehive
//
//  Created by Ryan Davies on 29/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVHook.h"
#import "BHVExample.h"
#import "BHVContext.h"

@interface BHVHook ()
@property (nonatomic, strong) NSMutableArray *accumulatedExamples;
@end

@implementation BHVHook

- (id)initWithPosition:(BHVHookPosition)position frequency:(BHVHookFrequency)frequency
{
    if (self = [super init]) {
        self.position = position;
        self.frequency = frequency;
    }
    return self;
}

- (BOOL)isHook
{
    return YES;
}

- (void)accept:(id<BHVNodeVisitor>)visitor
{
    if ([visitor respondsToSelector:@selector(visitHook:)]) [visitor visitHook:self];
}

- (void)visitExample:(BHVExample *)example
{
    [[self accumulatedExamples] addObject:example];
}

- (void)execute
{
    if ([self context]) {
        self.accumulatedExamples = [NSMutableArray array];
        [[self context] accept:self];
        
        if ([[self accumulatedExamples] containsObject:[self example]] == NO) {
            // Example is above hook in the context stack.
            return;
        }
    }
    
    if ([self frequency] == BHVHookFrequencyEach) {
        if ([self position] == BHVHookPositionBefore && [[self example] isExecuted]) return;
        if ([self position] == BHVHookPositionAfter && [[self example] isExecuted] == NO) return;
    }
    
    if ([self frequency] == BHVHookFrequencyAll) {
        NSMutableArray *executedExamples = [NSMutableArray array];
        NSArray *examples = [[self context] examples];
        [examples enumerateObjectsUsingBlock:^(BHVExample *example, NSUInteger idx, BOOL *stop) {
            if ([example isExecuted]) [executedExamples addObject:example];
        }];
        
        if ([self position] == BHVHookPositionBefore && [executedExamples count] > 0) return;
        if ([self position] == BHVHookPositionAfter && [executedExamples count] < [examples count]) return;
    }
    
    [super execute];
}

@end
