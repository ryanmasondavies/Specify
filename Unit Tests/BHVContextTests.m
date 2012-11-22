//
//  BHVContextTests.m
//  Beehive
//
//  Created by Ryan Davies on 21/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVContext.h"
#import "BHVExample.h"

@interface BHVContextTests : SenTestCase
@end

@implementation BHVContextTests

- (void)testCompilesExamples
{
    // Create a context:
    BHVContext *context = [[BHVContext alloc] init];
    [context setName:@"the something"];
    [context setImplementation:^{}];
    
    // Create examples:
    NSMutableArray *examples = [NSMutableArray array];
    examples[0] = [[BHVExample alloc] init];
    examples[1] = [[BHVExample alloc] init];
    [examples[0] setName:@"should do something"];
    [examples[1] setName:@"should do something else too"];
    
    // Track executions of all items:
    NSMutableDictionary *executed = [NSMutableDictionary dictionary];
    [context setImplementation:^{ executed[@"context"] = @YES; }];
    [examples[0] setImplementation:^{ executed[@"example1"] = @YES; }];
    [examples[1] setImplementation:^{ executed[@"example2"] = @YES; }];
    
    // Add examples to context:
    [context addItem:examples[0]];
    [context addItem:examples[1]];
    
    // Compile examples:
    NSArray *compiled = [context compile];
    
    // Executing the first compiled example should execute the context and example 1:
    [compiled[0] execute];
    STAssertEqualObjects([compiled[0] name], @"the something should do something", @"Should have concatenated the name to 'the something should do something'.");
    STAssertNotNil(executed[@"context"], @"Should have executed context implementation.");
    STAssertNotNil(executed[@"example1"], @"Should have executed example 1 implementation.");
    
    // Wipe the executed flags before going again:
    [executed removeAllObjects];
    
    // Executing the second compiled example should execute the context and example 2:
    [compiled[1] execute];
    STAssertEqualObjects([compiled[1] name], @"the something should do something else too", @"Should have concatenated the name to 'the something should do something else too'.");
    STAssertNotNil(executed[@"context"], @"Should have executed context implementation.");
    STAssertNotNil(executed[@"example2"], @"Should have executed example 2 implementation.");
}

@end
