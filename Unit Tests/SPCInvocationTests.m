//
//  SPCInvocationTests.m
//  Specify
//
//  Created by Ryan Davies on 15/01/2013.
//  Copyright (c) 2013 Ryan Davies. All rights reserved.
//

#import "SPCTestHelper.h"

@interface SPCInvocationTests : SenTestCase
@end

@implementation SPCInvocationTests

- (void)testInvokesExample
{
    id example = [OCMockObject mockForClass:[SPCExample class]];
    [[example expect] execute];
    SPCInvocation *invocation = [SPCInvocation invocationWithExample:example];
    [invocation invoke];
    [example verify];
}

@end
