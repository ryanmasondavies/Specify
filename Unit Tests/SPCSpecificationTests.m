//
//  SPCSpecificationTests.m
//  Specify
//
//  Created by Ryan Davies on 30/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "SPCTestHelper.h"

@interface SPCSpecificationTests : SenTestCase
@end

@implementation SPCSpecificationTests

- (void)testUsesSPCBuilder
{
    STAssertTrue([[SPCSpecification builder] isKindOfClass:[SPCBuilder class]], @"");
}

- (void)testForwardsNameToExample
{
    id example = [OCMockObject mockForClass:[SPCExample class]];
    [[[example expect] andReturn:@"fake name"] fullName];
    SPCSpecification *specification = [[SPCSpecification alloc] initWithInvocation:[INLInvocation invocationWithTest:example]];
    STAssertEqualObjects([specification name], @"fake name", @"");
    [example verify];
}

@end
