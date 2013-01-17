//
//  BHVBuilder.h
//  Behave
//
//  Created by Ryan Davies on 15/01/2013.
//  Copyright (c) 2013 Ryan Davies. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BHVGroup, BHVExample, BHVHook;

/** Used to construct grouped examples. */
@interface BHVBuilder : NSObject

/** The bottom-most group in the stack.
 
 When there are no groups added to the stack with enterGroup:, examples and hooks are added to the root group. When leaveGroup is called for the bottom-most group, the group is added to the root group.
 
 @return The root group to which examples and groups are added. */
- (BHVGroup *)rootGroup;

/** Pushes a new instance of BHVGroup to the stack.
 
 The new instance then becomes to the topmost group, to which all new groups, examples, and hooks will be added to.
 @note All calls to enterGroup: must be followed by a call to leaveGroup. 
 @param group The group to push to the stack. */
- (void)enterGroup:(BHVGroup *)group;

/** Pops the topmost instance of BHVGroup from the stack and adds it to the now-topmost group.
 * @note Calls to leaveGroup must take place after a call to enterGroup:. */
- (void)leaveGroup;

/** @param example The example to add to the topmost group. */
- (void)addExample:(BHVExample *)example;

/** @param hook The hook to add to the topmost group. */
- (void)addHook:(BHVHook *)hook;

@end
