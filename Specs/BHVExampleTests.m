//
//  BHVExampleTests.m
//  Beehive
//
//  Created by Ryan Davies on 10/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVExampleTests.h"
#import "BHVExample.h"

@implementation BHVExampleTests

- (void)testExamplesAreExecuted
{
    __block BOOL wasExecuted = NO;
    
    BHVExample *example = [[BHVExample alloc] init];
    [example setBlock:^{ wasExecuted = YES; }];
    [example execute];
    
    STAssertTrue(wasExecuted, @"should have executed its block");
}

@end
