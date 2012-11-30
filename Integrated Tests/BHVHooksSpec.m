//
//  BHVHooksSpec.m
//  Beehive
//
//  Created by Ryan Davies on 29/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "Beehive.h"

static NSUInteger beforeExecutionCount = 0;
static NSUInteger afterExecutionCount = 0;

SpecBegin(BHVBeforeEach)

describe(@"thing", ^{
    beforeEach(^{
        beforeExecutionCount ++;
    });
    
    describe(@"in another context", ^{
        it(@"should only have been executed once ", ^{
            [[@(beforeExecutionCount) should] beEqualTo:@1];
        });
    });
    
    it(@"should have been executed again", ^{
        [[@(beforeExecutionCount) should] beEqualTo:@2];
    });
});

SpecEnd

SpecBegin(BHVAfterEach)

describe(@"thing", ^{
    afterEach(^{
        afterExecutionCount ++;
    });
    
    describe(@"in another context", ^{
        it(@"should not have been executed yet", ^{
            [[@(afterExecutionCount) should] beEqualTo:@0];
        });
    });
    
    it(@"should have been executed", ^{
        [[@(afterExecutionCount) should] beEqualTo:@1];
    });
});

SpecEnd
