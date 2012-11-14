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

- (void)testConvenienceClassInitializer
{
    BHVImplementationBlock block = ^{};
    BHVExample *example = [BHVExample exampleWithDescription:@"does something" implementation:block];
    STAssertEquals([example description], @"does something", nil);
    STAssertEquals([example implementation], block, nil);
}

- (void)testConvenienceInitializer
{
    BHVImplementationBlock block = ^{};
    BHVExample *example = [[BHVExample alloc] initWithDescription:@"does something" implementation:block];
    STAssertEquals([example description], @"does something", nil);
    STAssertEquals([example implementation], block, nil);
}

- (void)testInvokesBlock
{
    BHVExample *example = [[BHVExample alloc] init];
    __block BOOL invoked = NO;
    [example setImplementation:^{ invoked = YES; }];
    
    [example execute];
    
    STAssertTrue(invoked, @"Block was not invoked.");
}

@end
