//
//  BHVContextFunctionTests.m
//  Beehive
//
//  Created by Ryan Davies on 21/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVContextFunction.h"
#import "BHVSuiteRegistry.h"
#import "BHVSuite.h"
#import "BHVContext.h"
#import "BHVExample.h"

@interface BHVContextFunctionTests : SenTestCase
@end

@implementation BHVContextFunctionTests

- (void)testAddsContextToUnlockedSuitesAndExamplesToContext
{
    BHVSuite *suite = [[BHVSuite alloc] init];
    [suite unlock];
    [[BHVSuiteRegistry sharedRegistry] registerSuite:suite forClass:[self class]];
    
    context(@"when something happens", ^{
        BHVExample *example = [[BHVExample alloc] init];
        [example setName:@"does something"];
        [example setImplementation:^{}];
        
        NSArray *suites = [[BHVSuiteRegistry sharedRegistry] unlockedSuites];
        [suites makeObjectsPerformSelector:@selector(addItem:) withObject:example];
    });
    
    BHVContext *context = (id)[suite itemAtIndex:0];
    STAssertEqualObjects([context name], @"when something happens", @"should have the name 'when something happens'");
    STAssertEqualObjects([[context itemAtIndex:0] name], @"does something", @"should have the item named 'does something'");
}

@end
