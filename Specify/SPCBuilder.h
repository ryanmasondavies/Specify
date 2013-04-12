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
#import <Inline/Inline.h>
@class INLGroup, SPCExample;

/** Used to construct grouped examples. */
@interface SPCBuilder : INLBuilder

/** Pushes a new instance of INLGroup to the stack.
 
 The new instance then becomes to the topmost group, to which all new groups, examples, and hooks will be added to.
 @note All calls to enterGroup: must be followed by a call to leaveGroup. 
 @param group The group to push to the stack. */
- (void)enterGroup:(INLGroup *)group;

/** Pops the topmost instance of INLGroup from the stack and adds it to the now-topmost group.
 * @note Calls to leaveGroup must take place after a call to enterGroup:. */
- (void)leaveGroup;

/** @param example The example to add to the topmost group. */
- (void)addExample:(SPCExample *)example;

/** @param hook The hook to add to the topmost group. */
- (void)addHook:(INLBlockHook *)hook;

@end
