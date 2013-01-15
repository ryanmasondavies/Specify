//
//  BHVSpecification.h
//  Behave
//
//  Created by Ryan Davies on 30/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@class BHVBuilder;

@interface BHVSpecification : SenTestCase

+ (void)setCurrentSpecification:(Class)specification;
+ (Class)currentSpecification;

+ (BHVBuilder *)builder;
- (void)loadExamples;
+ (void)reset;

@end
