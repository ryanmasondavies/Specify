//
//  BHVAfterEachSpec.m
//  Behave
//
//  Created by Ryan Davies on 01/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import <Posit/Posit.h>
#import "Behave.h"

SpecBegin(BHVAfterEach)

NSMutableString *foo = [NSMutableString string];

describe(@"afterEach", ^{
    afterEach(^{
        [foo appendString:@"bar"];
    });
    
    describe(@"in another context", ^{
        afterEach(^{
            [foo appendString:@"foo"];
        });
        
        it(@"should not have been executed yet", ^{
            [[foo should] beEqualTo:@""];
        });
        
        it(@"should have executed both hooks once", ^{
            [[foo should] beEqualTo:@"foobar"];
        });
    });
    
    it(@"should have executed both hooks twice", ^{
        [[foo should] beEqualTo:@"foobarfoobar"];
    });
    
    it(@"should have executed the outer hook once", ^{
        [[foo should] beEqualTo:@"foobarfoobarbar"];
    });
});

it(@"should have executed the outside afterAll block once more", ^{
    [[foo should] beEqualTo:@"foobarfoobarbarbar"];
});

SpecEnd
