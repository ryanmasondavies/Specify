//
//  SPCExampleTests.m
//  Specify
//
//  Created by Ryan Davies on 30/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "SPCTestHelper.h"

@interface SPCExampleTests : SenTestCase
@end

@implementation SPCExampleTests

- (void)testConcatenatesParentGroupLabelsAndExampleLabel
{
    // Create groups:
    NSArray *groups = @[[OCMockObject niceMockForClass:[INLGroup class]], [OCMockObject niceMockForClass:[INLGroup class]]];
    [[[groups[0] stub] andReturn:@"a cat"] label];
    [[[groups[1] stub] andReturn:@"when it is fat"] label];
    [[[groups[1] stub] andReturn:groups[0]] parent];
    
    // Create an example:
    SPCExample *example = [[SPCExample alloc] init];
    [example setLabel:@"should be lazy"];
    [example setParent:groups[1]];
    
    STAssertEqualObjects([example description], @"a cat when it is fat should be lazy", @"");
}

- (void)testUsesJustExampleLabelIfNotInGroup
{
    SPCExample *example = [[SPCExample alloc] init];
    [example setLabel:@"hello world"];
    STAssertEqualObjects([example description], @"hello world", @"");
}

@end
