//
//  BHVSpec.h
//  Beehive
//
//  Created by Ryan Davies on 11/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
@class BHVSuite;

@interface BHVSpec : SenTestCase

+ (Class)currentSpec;
+ (void)setCurrentSpec:(Class)spec;

+ (BHVSuite *)suite;
+ (void)resetSuites;

- (void)loadExamples;

@end
