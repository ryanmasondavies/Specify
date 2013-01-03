//
//  BHVBeforeAllSpec.m
//  Behave
//
//  Created by Ryan Davies on 01/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

SpecBegin(BHVBeforeAll)

NSMutableString *foo = [NSMutableString string];

describe(@"beforeAll", ^{
    beforeAll(^{
        [foo appendString:@"foo"];
    });
    
    it(@"should have been executed when the context opened", ^{
        [[foo should] beEqualTo:@"foo"];
    });
    
    it(@"should not have been executed twice", ^{
        [[foo should] beEqualTo:@"foo"];
    });
    
    describe(@"in another context", ^{
        beforeAll(^{
            [foo appendString:@"bar"];
        });
        
        it(@"should have been executed again", ^{
            [[foo should] beEqualTo:@"foobar"];
        });
        
        it(@"should not have been executed again in the same context", ^{
            [[foo should] beEqualTo:@"foobar"];
        });
    });
});

it(@"should not have executed any more hooks", ^{
    [[foo should] beEqualTo:@"foobar"];
});

SpecEnd
