//
//  SPCBuilder.h
//  Specify
//
//  Created by Ryan Davies on 15/01/2013.
//  Copyright (c) 2013 Ryan Davies. All rights reserved.
//

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
