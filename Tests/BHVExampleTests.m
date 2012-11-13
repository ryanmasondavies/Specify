//
//  BHVExampleTests.m
//  Beehive
//
//  Created by Ryan Davies on 10/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVExample.h"

@interface BHVExampleTests : SenTestCase
@end

@implementation BHVExampleTests

- (void)testInvokesBlock
{
    BHVExample *example = [[BHVExample alloc] init];
    __block BOOL invoked = NO;
    [example setBlock:^{ invoked = YES; }];
    
    [example execute];
    
    STAssertTrue(invoked, @"Block was not invoked.");
}

@end
