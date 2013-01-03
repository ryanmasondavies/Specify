//
//  BHVAfterAllSpec.m
//  Behave
//
//  Created by Ryan Davies on 01/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

SpecBegin(BHVAfterAll)

NSMutableString *order = [NSMutableString string];

afterAll(^{
    NSLog(@"Hook 1");
    [order appendString:@"1"];
});

it(@"should not have executed outer hook", ^{
    NSLog(@"Example 1");
    [[order should] beEqualTo:@""];
});

describe(@"in another context", ^{
    afterAll(^{
        NSLog(@"Hook 2");
        [order appendString:@"2"];
    });
    
    it(@"should still not have executed any hooks", ^{
        NSLog(@"Example 2");
        [[order should] beEqualTo:@""];
    });
});

SpecEnd
