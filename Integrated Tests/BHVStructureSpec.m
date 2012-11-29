//
//  BHVStructureSpec.m
//  Beehive
//
//  Created by Ryan Davies on 15/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "Beehive.h"

SpecBegin(BHVOneGroupOneExample)

describe(@"something", ^{
    it(@"does something", ^{
    });
});

SpecEnd

SpecBegin(BHVNestedExampleGroups)

describe(@"something", ^{
    context(@"in one context", ^{
        it(@"does one thing", ^{
        });
    });
    
    context(@"in another context", ^{
        it(@"does another thing", ^{
        });
    });
});

SpecEnd
