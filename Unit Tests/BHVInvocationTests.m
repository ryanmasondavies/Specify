//
//  BHVInvocationTests.m
//  Behave
//
//  Created by Ryan Davies on 15/01/2013.
//  Copyright (c) 2013 Ryan Davies. All rights reserved.
//

#import "BHVTestHelper.h"

@interface BHVInvocationTests : SenTestCase
@end

@implementation BHVInvocationTests

- (void)testInvokesExample
{
    id example = [OCMockObject mockForClass:[BHVExample class]];
    [[example expect] execute];
    BHVInvocation *invocation = [BHVInvocation invocationWithExample:example];
    [invocation invoke];
    [example verify];
}

@end
