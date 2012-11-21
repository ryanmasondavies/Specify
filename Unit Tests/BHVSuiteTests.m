//
//  BHVSuiteTests.m
//  Beehive
//
//  Created by Ryan Davies on 12/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVSuite.h"
#import "BHVExample.h"
#import "BHVContext.h"

@interface BHVSuite ()
@property (nonatomic, strong) BHVContext *currentContext;
@end

@interface BHVSuiteTests : SenTestCase
@property (nonatomic, strong) BHVSuite *suite;
@property (nonatomic, strong) BHVItem *item;
@end

@implementation BHVSuiteTests

- (void)setUp
{
    self.suite = [[BHVSuite alloc] init];
    self.item = [[BHVItem alloc] init];
    [[self item] setName:@"should do something"];
}

- (void)testRaisesAnExceptionWhenAddingItemsWhileLocked
{
    STAssertThrows([self.suite addItem:self.item], @"-addItem: should have thrown an exception.");
}

- (void)testAddsItemsToUnlockedSuite
{
    [[self suite] unlock];
    [self.suite addItem:self.item];
    STAssertEqualObjects([[self.suite itemAtIndex:0] name], @"should do something", @"-addItem: should have added an item to the suite.");
}

- (void)testAddsItemsToCurrentContextInAnUnlockedSuite
{
    BHVContext *context = [[BHVContext alloc] init];
    [[self suite] unlock];
    [self.suite setCurrentContext:context];
    [self.suite addItem:self.item];
    STAssertEqualObjects([[context itemAtIndex:0] name], @"should do something", @"-addItem: should have added an item to the context.");
}

@end
