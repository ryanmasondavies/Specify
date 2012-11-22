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

- (void)testCompilesExamples
{
    // Create an unlocked suite:
    BHVSuite *suite = [[BHVSuite alloc] init];
    [suite unlock];
    
    // Create three contexts, each with an example.
    // Track the execution of all contexts and examples.
    NSMutableDictionary *executed = [NSMutableDictionary dictionary];
    NSMutableArray *contexts = [NSMutableArray array];
    [@[@"context1", @"context2", @"context3"] enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL *stop) {
        // Create a context:
        contexts[idx] = [[BHVContext alloc] init];
        [contexts[idx] setName:name];
        [contexts[idx] setImplementation:^{ executed[name] = @YES; }];
        
        // Create an example:
        BHVExample *example = [[BHVExample alloc] init];
        [example setName:@"example"];
        [example setImplementation:^{
            executed[[NSString stringWithFormat:@"%@-example", name]] = @YES;
        }];
        
        // Add example to context:
        [contexts[idx] addItem:example];
        
        // Add context to suite:
        [suite addItem:contexts[idx]];
    }];
    
    // Compile suite:
    NSArray *compiled = [suite compile];
    
    // Executing the first compiled example should execute context 1 and its example:
    [compiled[0] execute];
    STAssertNotNil(executed[@"context1"], @"Should have executed context 1's implementation.");
    STAssertNotNil(executed[@"context1-example"], @"Should have executed context 1's example.");
    
    // Wipe the executed flags before going again:
    [executed removeAllObjects];
    
    // Executing the second compiled example should execute the context and its example:
    [compiled[1] execute];
    STAssertNotNil(executed[@"context2"], @"Should have executed context 2's implementation.");
    STAssertNotNil(executed[@"context2-example"], @"Should have executed context 2's example.");
}

@end
