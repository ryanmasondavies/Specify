//
//  BHVItFunctionTests.m
//  Beehive
//
//  Created by Ryan Davies on 29/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVSpec.h"
#import "BHVSuiteRegistry.h"
#import "BHVSuite.h"
#import "BHVExample.h"
#import "BHVTestHelper.h"

void it(NSString *name, void(^block)(void))
{
    // Build an example from the attributes:
    BHVExample *example = [[BHVExample alloc] init];
    [example setName:name];
    [example setBlock:block];
    
    // Add the example to the suite for the spec being loaded:
    [[BHVSuiteRegistry suiteForClass:[BHVSpec currentSpec]] addNode:example];
}

@interface BHVItFunctionTests : SenTestCase
@end

@implementation BHVItFunctionTests

- (void)testAddsExampleToCurrentSpecSuite
{
    // Set the current spec:
    [BHVSpec setCurrentSpec:[BHVTestSpec1 class]];
    
    // Add a suite for the current spec:
    BHVSuite *suite = [[BHVSuite alloc] init];
    [BHVSuiteRegistry registerSuite:suite forClass:[BHVTestSpec1 class]];
    
    // Execute the it function:
    NSString *name = @"should do something";
    void(^block)(void) = ^{};
    it(name, block);
    
    // Check that an example has been added to the suite with the name and block:
    BHVExample *example = (BHVExample *)[suite nodeAtIndex:0];
    [[[example name] should] beEqualTo:name];
    [[[example block] should] beEqualTo:block];
}

@end
