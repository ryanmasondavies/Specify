//
//  BHVTestHelper.m
//  Behave
//
//  Created by Ryan Davies on 02/01/2013.
//  Copyright (c) 2013 Ryan Davies. All rights reserved.
//

#import "BHVTestHelper.h"

@implementation BHVTestSpecification

- (void)loadExamples
{
}

@end

@implementation BHVSpecificationA

@end

@implementation BHVSpecificationB

@end

@implementation BHVSpecificationWithThreeExamples

- (void)loadExamples
{
    it(@"example 1", ^{});
    it(@"example 2", ^{});
    it(@"example 3", ^{});
}

@end

@implementation BHVSpecificationWithUnorderedNestedExamples

- (void)loadExamples
{
    it(@"example 1", ^{});
    context(@"group 1", ^{
        context(@"group 2", ^{
            it(@"example 2", ^{});
        });
    });
    it(@"example 3", ^{});
}

@end

@implementation BHVSpecificationWithHooks

- (void)loadExamples
{
    beforeEach(^{});
    it(@"Example", ^{});
    afterEach(^{});
}

@end
