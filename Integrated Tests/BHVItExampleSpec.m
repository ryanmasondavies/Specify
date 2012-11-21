//
//  BHVItExampleSpec.m
//  Beehive
//
//  Created by Ryan Davies on 15/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "Beehive.h"

@interface BHVItExampleSpec : BHVSpec
@end

@implementation BHVItExampleSpec

- (void)loadExamples
{
    it(@"should do something", ^{});

    //describe(@"something else", ^{
    //    it(@"should do something else", ^{});
    //});
}

@end
