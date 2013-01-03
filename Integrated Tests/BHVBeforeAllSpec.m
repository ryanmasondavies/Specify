//
//  BHVBeforeAllSpec.m
//  Behave
//
//  Created by Ryan Davies on 01/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

SpecBegin(BHVBeforeAll)

NSMutableString *order = [NSMutableString string];

beforeAll(^{
    [order appendString:@"1"];
});

it(@"should have executed outer hook once", ^{
    [[order should] beEqualTo:@"1"];
});

describe(@"in another context", ^{
    beforeAll(^{
        [order appendString:@"2"];
    });
    
    it(@"should have executed both hooks once", ^{
        [[order should] beEqualTo:@"12"];
    });
});

SpecEnd
