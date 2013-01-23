//
//  SPCAfterEachSpec.m
//  Specify
//
//  Created by Ryan Davies on 01/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

SpecBegin(SPCAfter)

NSMutableString *order = [NSMutableString string];

after(^{
    [order appendString:@"1"];
});

it(@"should not have executed yet", ^{
    [[order should] beEqualTo:@""];
});

describe(@"in another group", ^{
    after(^{
        [order appendString:@"2"];
    });
    
    it(@"should have executed the outer hook once", ^{
        [[order should] beEqualTo:@"1"];
    });
    
    it(@"should have executed the outer hook twice and the inner hook once, executing the inner hook first", ^{
        [[order should] beEqualTo:@"121"];
    });
});

SpecEnd

SpecBegin(SPCAfterEach)

NSMutableString *order = [NSMutableString string];

afterEach(^{
    [order appendString:@"1"];
});
    
it(@"should not have executed yet", ^{
    [[order should] beEqualTo:@""];
});

describe(@"in another group", ^{
    afterEach(^{
        [order appendString:@"2"];
    });
    
    it(@"should have executed the outer hook once", ^{
        [[order should] beEqualTo:@"1"];
    });
    
    it(@"should have executed the outer hook twice and the inner hook once, executing the inner hook first", ^{
        [[order should] beEqualTo:@"121"];
    });
});

SpecEnd
