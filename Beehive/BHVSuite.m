//
//  BHVSuite.m
//  Beehive
//
//  Created by Ryan Davies on 11/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVSuite.h"
#import "BHVExample.h"

@interface BHVSuite ()
@property (nonatomic, strong) NSMutableArray *examples;
@end

@implementation BHVSuite

- (id)init
{
    if (self = [super init]) {
        self.examples = [NSMutableArray array];
        [self lock];
    }
    
    return self;
}

- (void)lock
{
    self.locked = YES;
}

- (void)unlock
{
    self.locked = NO;
}

- (void)addExample:(BHVExample *)example
{
    if ([self isLocked] == NO)
        [[self examples] addObject:example];
    else
        [NSException raise:@"BHVSuiteLockException" format:@"Cannot add examples to a locked suite."];
}

- (BHVExample *)exampleAtIndex:(NSUInteger)index
{
    return [[self examples] objectAtIndex:index];
}

- (NSUInteger)numberOfExamples
{
    return [[self examples] count];
}

- (NSArray *)compiledExamples
{
    // TODO: Compile examples with their contexts.
    return [NSArray arrayWithArray:[self examples]];
}

@end
