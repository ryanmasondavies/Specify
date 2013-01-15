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

+ (BHVBuilder *)builder;
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
void beforeEach(void(^block)(void));
void afterEach(void(^block)(void));

#define SpecEnd \
} \
@end
