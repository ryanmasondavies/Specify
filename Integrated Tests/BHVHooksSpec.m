//
//  BHVHooksSpec.m
//  Beehive
//
//  Created by Ryan Davies on 29/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "Beehive.h"

static NSUInteger executionCount = 0;

SpecBegin(BHVBeforeEach)

describe(@"thing", ^{
    beforeEach(^{
        executionCount ++;
    });
    
    describe(@"in another context", ^{
        it(@"should only have been executed once ", ^{
            [[@(executionCount) should] beEqualTo:@1];
        });
    });
    
    it(@"should have been executed again", ^{
        [[@(executionCount) should] beEqualTo:@2];
    });
});

SpecEnd
