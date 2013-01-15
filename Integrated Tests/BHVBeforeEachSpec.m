//
//  BHVHooksSpec.m
//  Behave
//
//  Created by Ryan Davies on 29/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

SpecBegin(BHVBefore)

NSMutableString *order = [NSMutableString string];

before(^{
    [order appendString:@"1"];
});

it(@"should have executed outer hook once", ^{
    [[order should] beEqualTo:@"1"];
});

describe(@"in another group", ^{
    before(^{
        [order appendString:@"2"];
    });
    
    it(@"should have executed outer hook twice and inner hook once", ^{
        [[order should] beEqualTo:@"112"];
    });
});

SpecEnd

SpecBegin(BHVBeforeEach)

NSMutableString *order = [NSMutableString string];

beforeEach(^{
    [order appendString:@"1"];
});

it(@"should have executed outer hook once", ^{
    [[order should] beEqualTo:@"1"];
});

describe(@"in another group", ^{
    beforeEach(^{
        [order appendString:@"2"];
    });
    
    it(@"should have executed outer hook twice and inner hook once", ^{
        [[order should] beEqualTo:@"112"];
    });
});

SpecEnd
