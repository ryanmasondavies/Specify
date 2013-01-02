//
//  BHVSpecification.h
//  Behave
//
//  Created by Ryan Davies on 30/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@class BHVContext, BHVExample, BHVHook;

@interface BHVSpecification : SenTestCase

+ (void)enterContext:(BHVContext *)context;
+ (void)leaveContext;

+ (void)addExample:(BHVExample *)example;
+ (void)addHook:(BHVHook *)hook;

- (void)loadExamples;

+ (void)reset;

@end

#define SpecBegin(class) \
@interface class##Specification : BHVSpecification \
@end \
@implementation class##Specification \
- (void)loadExamples \
{

void it(NSString *name, void(^block)(void));
void context(NSString *name, void(^block)(void));
void describe(NSString *name, void(^block)(void));
void beforeAll(void(^block)(void));
void afterAll(void(^block)(void));
void beforeEach(void(^block)(void));
void afterEach(void(^block)(void));

#define SpecEnd \
} \
@end
