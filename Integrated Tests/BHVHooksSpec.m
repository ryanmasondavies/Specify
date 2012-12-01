//
//  BHVHooksSpec.m
//  Beehive
//
//  Created by Ryan Davies on 29/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "Beehive.h"

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
