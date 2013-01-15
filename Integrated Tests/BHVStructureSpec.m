//
//  BHVStructureSpec.m
//  Behave
//
//  Created by Ryan Davies on 15/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

SpecBegin(BHVOneGroupOneExample)

describe(@"something", ^{
    it(@"does something", ^{
    });
});

SpecEnd

SpecBegin(BHVNestedExampleGroups)

describe(@"something", ^{
    context(@"in one group", ^{
        it(@"does one thing", ^{
        });
    });
    
    context(@"in another group", ^{
        it(@"does another thing", ^{
        });
    });
});

SpecEnd
