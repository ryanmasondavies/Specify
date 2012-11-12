//
//  BHVSuite.m
//  Beehive
//
//  Created by Ryan Davies on 11/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVSuite.h"
#import "BHVExample.h"
#import "BHVInvocation.h"

@interface BHVSuite ()
@property (nonatomic, strong) NSMutableArray *examples;
@end

@implementation BHVSuite

+ (id)sharedSuite
{
    static dispatch_once_t pred;
    static BHVSuite *suite = nil;
    dispatch_once(&pred, ^{ suite = [[self alloc] init]; });
    return suite;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.examples = [NSMutableArray array];
    }
    return self;
}

- (NSArray *)invocations
{
    NSMutableArray *invocations = [NSMutableArray array];
    [[self examples] enumerateObjectsUsingBlock:^(BHVExample *example, NSUInteger idx, BOOL *stop) {
        BHVInvocation *invocation = [BHVInvocation emptyInvocation];
        [invocation setExample:example];
        [invocations addObject:invocation];
    }];
    
    return [NSArray arrayWithArray:invocations];
}

- (void)addExample:(BHVExample *)example
{
    [[self examples] addObject:example];
}

@end

#pragma mark - Defining behaviour

void example(NSString *description, BHVVoidBlock block)
{
    BHVExample *example = [[BHVExample alloc] init];
    [example setDescription:description];
    [example setBlock:block];
    [[BHVSuite sharedSuite] addExample:example];
}

void it(NSString *description, BHVVoidBlock block)
{
    example(description, block);
}
