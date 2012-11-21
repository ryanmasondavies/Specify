//
//  BHVItTests.m
//  Beehive
//
//  Created by Ryan Davies on 21/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVSpec.h"
#import "BHVSuiteRegistry.h"
#import "BHVSuite.h"
#import "BHVExample.h"
#import "BHVIt.h"

@interface BHVTestSpec1 : BHVSpec; @end
@implementation BHVTestSpec1; @end

@interface BHVTestSpec2 : BHVSpec; @end
@implementation BHVTestSpec2; @end

@interface BHVTestSpec3 : BHVSpec; @end
@implementation BHVTestSpec3; @end

@interface BHVItTests : SenTestCase
@end

@implementation BHVItTests

- (void)testCreatesAndAddsExampleToUnlockedSuitesInRegistry
{
    NSMutableArray *suites = [NSMutableArray array];
    for (NSUInteger i = 0; i < 3; i ++) {
        suites[i] = [[BHVSuite alloc] init];
        [[BHVSuiteRegistry sharedRegistry] registerSuite:suites[i] forClass:NSClassFromString([NSString stringWithFormat:@"BHVTestSpec%d", (i + 1)])];
    }
    
    [suites[0] unlock];
    [suites[2] unlock];
    
    BHVImplementationBlock block = ^{};
    it(@"should do something", block);
    
    STAssertEqualObjects([[suites[0] exampleAtIndex:0] name], @"should do something", @"'it' should have added an example named 'should do something' to suite 1.");
    STAssertEqualObjects([[suites[0] exampleAtIndex:0] implementation], block, @"'it' should have added an example with the given block to suite 1.");
    
    STAssertFalse([suites[1] numberOfExamples], @"'it' should not have added an example to suite 2.");
    
    STAssertEqualObjects([[suites[2] exampleAtIndex:0] name], @"should do something", @"'it' should have added an example named 'should do something' to suite 3.");
    STAssertEqualObjects([[suites[2] exampleAtIndex:0] implementation], block, @"'it' should have added an example with the given block to suite 3.");
}

@end
