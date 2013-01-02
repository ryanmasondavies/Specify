//
//  BHVSpecification.h
//  Behave
//
//  Created by Ryan Davies on 30/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@class BHVContext, BHVExample, BHVHook;

@interface BHVInvocation : NSInvocation
@property (strong, nonatomic) BHVExample *example;
+ (instancetype)invocationWithExample:(BHVExample *)example;
@end

@interface BHVSpecification : SenTestCase

+ (void)enterContext:(BHVContext *)context;
+ (void)leaveContext;

+ (void)addExample:(BHVExample *)example;
+ (void)addHook:(BHVHook *)hook;

@end
