//
//  BHVExampleAccumulator.m
//  Beehive
//
//  Created by Ryan Davies on 28/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVExampleAccumulator.h"
#import "BHVNode.h"

@interface BHVExampleAccumulator ()
@property (nonatomic, strong) BHVNode *node;
@property (nonatomic, strong) NSMutableArray *accumulatedExamples;
@end

@implementation BHVExampleAccumulator

- (id)initWithNode:(BHVNode *)node
{
    if (self = [super init]) self.node = node;
    return self;
}

- (NSArray *)examples
{
    self.accumulatedExamples = [NSMutableArray array];
    [self.node accept:self];
    return [NSArray arrayWithArray:[self accumulatedExamples]];
}

- (void)visitExample:(BHVExample *)example
{
    [[self accumulatedExamples] addObject:example];
}

@end
