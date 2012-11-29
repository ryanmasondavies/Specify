//
//  BHVExampleTests.m
//  Beehive
//
//  Created by Ryan Davies on 28/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVExample.h"
#import "BHVContext.h"

@interface PSTBeMatcher ()
- (BOOL)beExecuted;
@end

@interface BHVExampleTests : SenTestCase
@end

@implementation BHVExampleTests

- (void)test_Execution_InvokesBlock
{
    __block BOOL invoked = NO;
    BHVExample *example = [[BHVExample alloc] init];
    [example setBlock:^{ invoked = YES; }];
    [example execute];
    [[@(invoked) should] beTrue];
}

- (void)test_Execution_MarksAsExecuted
{
    BHVExample *example = [[BHVExample alloc] init];
    [[example shouldNot] beExecuted];
    [example execute];
    [[example should] beExecuted];
}

- (void)test_FullName_IncludesParentContextNames
{
    BHVExample *example = [[BHVExample alloc] init];
    [example setName:@"should do something"];
    
    BHVContext *nestedContext = [[BHVContext alloc] init];
    [nestedContext setName:@"in some state"];
    [nestedContext addNode:example];
    
    BHVContext *topContext = [[BHVContext alloc] init];
    [topContext setName:@"the thing"];
    [topContext addNode:nestedContext];
    
    [[[example fullName] should] beEqualTo:@"the thing in some state should do something"];
}

@end
