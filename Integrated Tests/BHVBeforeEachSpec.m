//
//  BHVHooksSpec.m
//  Behave
//
//  Created by Ryan Davies on 29/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

SpecBegin(BHVBeforeEach)

NSMutableString *order = [NSMutableString string];

beforeEach(^{
    NSLog(@"Before each 1");
    [order appendString:@"1"];
});

it(@"should have executed outer hook once", ^{
    NSLog(@"Example 1");
    [[order should] beEqualTo:@"1"];
});

describe(@"in another context", ^{
    beforeEach(^{
        NSLog(@"Before each 2");
        [order appendString:@"2"];
    });
    
    it(@"should have executed outer hook twice and inner hook once", ^{
        NSLog(@"Example 2");
        [[order should] beEqualTo:@"112"];
    });
});

SpecEnd
