//
//  BHVStructureSpec.m
//  Beehive
//
//  Created by Ryan Davies on 15/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "Beehive.h"

@interface BHVStructureSpec : BHVSpec
@end

@implementation BHVStructureSpec

- (void)loadExamples
{
    it(@"should do something", ^{});

    context(@"something else", ^{
        it(@"should do something else", ^{});
    });
}

@end