//
//  SPCGroup.h
//  Specify
//
//  Created by Ryan Davies on 30/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SPCExample, SPCHook;

/** A group within which examples, hooks, and other groups can be nested and later retrieved. */
@interface SPCGroup : NSObject

/** @param name The name to assign to the group.
 @return A new instance of SPCGroup, with the given name. */
- (instancetype)initWithName:(NSString *)name;

/** Nests a group within a group, and assigns the [SPCGroup parentGroup] to the group which the subgroup is being added to.
 @param group The group to add. */
- (void)addGroup:(SPCGroup *)group;

/** Adds an example to the group, and assigns the [SPCExample parentGroup] to the group which the example is being added to.
 @param example The example to add. */
- (void)addExample:(SPCExample *)example;

/** Adds a hook to the group, and assigns the [SPCHook parentGroup] to the group which the hook is being added to.
 @param hook The hook to add. */
- (void)addHook:(SPCHook *)hook;

/** The name by which the group can be identified, used by SPCSpecification to generate informative names. */
@property (copy, nonatomic) NSString *name;

/** The groups which have been added using addGroup:, in the order they were added. */
@property (strong, nonatomic) NSArray *groups;

/** The examples which have been added using addExample:, in the order they were added. */
@property (strong, nonatomic) NSArray *examples;

/** The hooks which have been added using addHook:, in the order they were added. */
@property (strong, nonatomic) NSArray *hooks;

/** The group which this group has been added to. A group is assigned to the child when addGroup: is called. */
@property (weak, nonatomic) SPCGroup *parentGroup;

@end
