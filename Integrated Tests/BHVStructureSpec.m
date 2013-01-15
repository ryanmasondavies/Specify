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
    group(@"in one group", ^{
        it(@"does one thing", ^{
        });
    });
    
    group(@"in another group", ^{
        it(@"does another thing", ^{
        });
    });
});

SpecEnd
