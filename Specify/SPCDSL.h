// The MIT License
// 
// Copyright (c) 2013 Ryan Davies
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

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

/** Examples can be defined within a *context*, e.g: how does the module behave when its state is set to *whatever*? */
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
