//
//  BHVHooksSpec.m
//  Behave
//
//  Created by Ryan Davies on 29/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import <Posit/Posit.h>
#import "Behave.h"

SpecBegin(BHVBeforeEach)

NSMutableString *foo = [NSMutableString string];

describe(@"beforeEach", ^{
    beforeEach(^{
        [foo appendString:@"foo"];
    });
    
    describe(@"in another context", ^{
        beforeEach(^{
            [foo appendString:@"bar"];
        });
        
        it(@"should have executed both hooks", ^{
            [[foo should] beEqualTo:@"foobar"];
        });
        
        it(@"should have executed both hooks again", ^{
            [[foo should] beEqualTo:@"foobarfoobar"];
        });
    });
    
    it(@"should have executed the outer hook a third time", ^{
        [[foo should] beEqualTo:@"foobarfoobarfoo"];
    });
    
    it(@"should have executed the outer hook a fourth time", ^{
        [[foo should] beEqualTo:@"foobarfoobarfoofoo"];
    });
});

it(@"should not have executed any more hooks", ^{
    [[foo should] beEqualTo:@"foobarfoobarfoofoo"];
});

SpecEnd
