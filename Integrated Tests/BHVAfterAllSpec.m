//
//  BHVAfterAllSpec.m
//  Behave
//
//  Created by Ryan Davies on 01/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

SpecBegin(BHVAfterAll)

NSMutableString *foo = [NSMutableString string];

describe(@"afterAll", ^{
    afterAll(^{
        [foo appendString:@"bar"];
    });
    
    describe(@"in another context", ^{
        afterAll(^{
            [foo appendString:@"foo"];
        });
        
        it(@"should not have been executed yet", ^{
            [[foo should] beEqualTo:@""];
        });
        
        it(@"should still not have been executed yet", ^{
            [[foo should] beEqualTo:@""];
        });
    });
    
    it(@"should have executed when the context closed", ^{
        [[foo should] beEqualTo:@"foo"];
    });
    
    it(@"should not have executed again", ^{
        [[foo should] beEqualTo:@"foo"];
    });
});

it(@"should have executed the outside afterAll block", ^{
    [[foo should] beEqualTo:@"foobar"];
});

SpecEnd
