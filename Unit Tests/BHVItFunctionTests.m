//
//  BHVExampleDSLTests.m
//  Beehive
//
//  Created by Ryan Davies on 21/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVItFunction.h"
#import "BHVSpec.h"
#import "BHVSuiteRegistry.h"
#import "BHVSuite.h"
#import "BHVExample.h"
#import "BHVTestHelper.h"

@interface BHVExampleDSLTests : SenTestCase
@end

@implementation BHVExampleDSLTests

- (void)testCreatesAndAddsExampleToUnlockedSuitesInRegistry
{
    NSMutableArray *suites = [NSMutableArray array];
    for (NSUInteger i = 0; i < 3; i ++) {
        suites[i] = [[BHVSuite alloc] init];
        Class klass = NSClassFromString([NSString stringWithFormat:@"BHVTestSpec%d", (i + 1)]);
        [[BHVSuiteRegistry sharedRegistry] registerSuite:suites[i] forClass:klass];
    }
    
    [suites[0] unlock];
    [suites[2] unlock];
    
    BHVImplementationBlock block = ^{};
    it(@"should do something", block);
    
    STAssertEqualObjects([[suites[0] itemAtIndex:0] name], @"should do something", @"'it' should have added an example named 'should do something' to suite 1.");
    STAssertEqualObjects([[suites[0] itemAtIndex:0] implementation], block, @"'it' should have added an example with the given block to suite 1.");
    
    STAssertThrows([suites[1] itemAtIndex:0], @"'it' should not have added an example to suite 2.");
    
    STAssertEqualObjects([[suites[2] itemAtIndex:0] name], @"should do something", @"'it' should have added an example named 'should do something' to suite 3.");
    STAssertEqualObjects([[suites[2] itemAtIndex:0] implementation], block, @"'it' should have added an example with the given block to suite 3.");
}

@end
