//
//  BHVDSL.h
//  Behave
//
//  Created by Ryan Davies on 15/01/2013.
//  Copyright (c) 2013 Ryan Davies. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BHVSpecification;

#define SpecBegin(class) \
@interface class##Specification : BHVSpecification \
@end \
@implementation class##Specification \
- (void)loadExamples \
{

void it(NSString *name, void(^block)(void));
void context(NSString *name, void(^block)(void));
void describe(NSString *name, void(^block)(void));
void when(NSString *name, void(^block)(void));
void beforeEach(void(^block)(void));
void before(void(^block)(void));
void afterEach(void(^block)(void));

#define SpecEnd \
} \
@end
