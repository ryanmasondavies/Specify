//
//  SPCDSL.h
//  Specify
//
//  Created by Ryan Davies on 15/01/2013.
//  Copyright (c) 2013 Ryan Davies. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SPCSpecification;

#define SpecBegin(class) \
@interface class##Specification : SPCSpecification \
@end \
@implementation class##Specification \
- (void)loadExamples \
{

/** Allows for the definition of behaviour in conversational terms: *it* should do something. */
void it(NSString *label, void(^block)(void));

/** Examples can be defined within a *context*, e.g: how does the module Specify when its state is set to whatever? */
void context(NSString *label, void(^block)(void));

/** A module can be *described* in conversational terms: I want to *describe* the module. *It* should do something. */
void describe(NSString *label, void(^block)(void));

/** A module can be contextualized in terms of an event: *when* something happens, *it* should do something. */
void when(NSString *label, void(^block)(void));

/** Executes a piece of code before each example in the same and any nested groups is invoked. Multiple examples sometimes need to exist within the same environment. */
void before(void(^block)(void));

/** Executes a piece of code before each example in the same and any nested groups is invoked. Multiple examples sometimes need to exist within the same environment. */
void beforeEach(void(^block)(void));

/** Executes a piece of code after each example in the same and any nested groups is invoked. Multiple examples sometimes need to exist within the same environment, and that environment occassionally requires breaking down after the example has been invoked. */
void after(void(^block)(void));

/** Executes a piece of code after each example in the same and any nested groups is invoked. Multiple examples sometimes need to exist within the same environment, and that environment occassionally requires breaking down after the example has been invoked. */
void afterEach(void(^block)(void));

#define SpecEnd \
} \
@end
