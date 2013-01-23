//
//  SPCTestHelper.m
//  Specify
//
//  Created by Ryan Davies on 02/01/2013.
//  Copyright (c) 2013 Ryan Davies. All rights reserved.
//

#import "SPCTestHelper.h"

@implementation SPCTestSpecification

- (void)loadExamples
{
}

@end

@implementation SPCSpecificationA

@end

@implementation SPCSpecificationB

@end

@implementation SPCSpecificationWithThreeExamples

- (void)loadExamples
{
    it(@"example 1", ^{});
    it(@"example 2", ^{});
    it(@"example 3", ^{});
}

@end

@implementation SPCSpecificationWithUnorderedNestedExamples

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

@implementation SPCSpecificationWithHooks

- (void)loadExamples
{
    beforeEach(^{});
    it(@"Example", ^{});
    afterEach(^{});
}

@end
