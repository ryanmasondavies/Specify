//
//  BHVSpecification.h
//  Behave
//
//  Created by Ryan Davies on 30/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@class BHVGroup, BHVExample, BHVHook;

@interface BHVSpecification : SenTestCase

+ (void)enterGroup:(BHVGroup *)group;
+ (void)leaveGroup;

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
void group(NSString *name, void(^block)(void));
void describe(NSString *name, void(^block)(void));
void beforeEach(void(^block)(void));
void afterEach(void(^block)(void));

#define SpecEnd \
} \
@end
