//
//  BHVExampleTests.m
//  Beehive
//
//  Created by Ryan Davies on 10/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVSpec.h"
#import "BHVExample.h"
#import "BHVMacros.h"

SpecBegin(ExampleSpec)

example(@"example 1", ^{
    // test that examples defined using 'example' are considered valid.
});

SpecEnd

SpecBegin(ItSpec)

it(@"example 1", ^{
    // test that examples defined using 'it' are considered valid.
});

SpecEnd
