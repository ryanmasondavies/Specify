//
//  BHVInvocationTests.m
//  Beehive
//
//  Created by Ryan Davies on 12/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVInvocation.h"
#import "BHVExample.h"

@interface BHVInvocationTests : SenTestCase
@end

@implementation BHVInvocationTests

- (void)testExecutesExample
{
    id example = [OCMockObject mockForClass:[BHVExample class]];
    [[example expect] execute];
    
    BHVInvocation *invocation = [BHVInvocation emptyInvocation];
    [invocation setExample:example];
    [invocation invoke];
    
    [example verify];
}

@end
