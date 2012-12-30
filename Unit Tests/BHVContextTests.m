//
//  BHVContextTests.m
//  Behave
//
//  Created by Ryan Davies on 30/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "BHVContext.h"
#import "BHVExample.h"
#import "BHVHook.h"

@interface BHVContext ()
@property (strong, nonatomic) NSMutableArray *contexts;
@property (strong, nonatomic) NSMutableArray *examples;
@property (strong, nonatomic) NSMutableArray *hooks;
@end

@interface BHVContextTests : SenTestCase
@end

@implementation BHVContextTests

- (void)testAddingContexts
{
    BHVContext *parentContext = [BHVContext new];
    BHVContext *childContext = [BHVContext new];
    [parentContext addContext:childContext];
    STAssertTrue([[parentContext contexts] containsObject:childContext], @"Should have added child context to parent.");
}

- (void)testAddingExamples
{
    BHVExample *example = [BHVExample new];
    BHVContext *context = [BHVContext new];
    [context addExample:example];
    STAssertTrue([[context examples] containsObject:example], @"Should have added example to context.");
}

- (void)testAddingHooks
{
    BHVHook *hook = [BHVHook new];
    BHVContext *context = [BHVContext new];
    [context addHook:hook];
    STAssertTrue([[context hooks] containsObject:hook], @"Should have added hook to context.");
}

@end
