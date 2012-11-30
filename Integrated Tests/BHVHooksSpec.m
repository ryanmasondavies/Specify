//
//  BHVHooksSpec.m
//  Beehive
//
//  Created by Ryan Davies on 29/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "Beehive.h"

static NSUInteger beforeEachCount = 0;
static NSUInteger afterEachCount = 0;
static NSUInteger beforeAllCount = 0;
static NSUInteger afterAllCount = 0;

SpecBegin(BHVBeforeEach)

describe(@"thing", ^{
    beforeEach(^{
        beforeEachCount ++;
    });
    
    describe(@"in another context", ^{
        it(@"should only have been executed once ", ^{
            [[@(beforeEachCount) should] beEqualTo:@1];
        });
    });
    
    it(@"should have been executed again", ^{
        [[@(beforeEachCount) should] beEqualTo:@2];
    });
});

SpecEnd

SpecBegin(BHVAfterEach)

describe(@"thing", ^{
    afterEach(^{
        afterEachCount ++;
    });
    
    describe(@"in another context", ^{
        it(@"should not have been executed yet", ^{
            [[@(afterEachCount) should] beEqualTo:@0];
        });
    });
    
    it(@"should have been executed", ^{
        [[@(afterEachCount) should] beEqualTo:@1];
    });
});

SpecEnd

SpecBegin(BHVBeforeAll)

describe(@"thing", ^{
    beforeAll(^{
        beforeAllCount ++;
    });
    
    it(@"should have been executed", ^{
        [[@(beforeAllCount) should] beEqualTo:@1];
    });
    
    describe(@"in another context", ^{
        beforeAll(^{
            beforeAllCount ++;
        });
        
        it(@"should have been executed again ", ^{
            [[@(beforeAllCount) should] beEqualTo:@2];
        });
    });
    
    it(@"should not have executed any more", ^{
        [[@(beforeAllCount) should] beEqualTo:@2];
    });
});

SpecEnd

SpecBegin(BHVAfterAll)

describe(@"thing", ^{
    afterAll(^{
        afterAllCount ++;
    });
    
    describe(@"in another context", ^{
        afterAll(^{
            afterAllCount ++;
        });
        
        it(@"should not have been executed yet", ^{
            [[@(afterAllCount) should] beEqualTo:@0];
        });
    });
    
    it(@"should have executed when the context closed", ^{
        [[@(afterEachCount) should] beEqualTo:@1];
    });
    
    it(@"should not have executed again", ^{
        [[@(afterAllCount) should] beEqualTo:@1];
    });
});

SpecEnd
