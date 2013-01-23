//
//  SPCExample.h
//  Specify
//
//  Created by Ryan Davies on 30/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SPCGroup;

typedef NS_ENUM(NSInteger, SPCExampleState) {
    SPCExampleStatePending,
    SPCExampleStateReady,
    SPCExampleStateExecuted
};

/** An example which defines a single piece of behaviour within a system.
 
 An example has a name, a block, and exists within a group identified by parentGroup. Hooks in the parent and subsequent parent groups are handled in execute, and are used to provide an environment in which the example is defined. */
@interface SPCExample : NSObject

/** Executes an example and its hooks.
 
 Performs the following operations:
 
 1. Executes all hooks which respond with YES to [SPCHook isExecutableBeforeExample:] in *outermost first* order. This means that hooks in a root group are executed prior to hooks in an immediate parent group.
 2. Invokes the example's block.
 3. Executes all hooks which respond with YES to [SPCHook isExecutableAfterExample:] in *innermost first* order. This means that hooks in an immediate parent group are executed prior to hooks in a root group.
 4. Sets the example's state to SPCExampleStateExecuted.
 @note Hooks are collected by recursively invoking parentGroup on the result, starting with the example's parentGroup.
 */
- (void)execute;

/** The full name for the example, made by accumulating the names of parent groups and concatenating them with name. */
- (NSString *)fullName;

/** A name by which an example is identified, used to provide useful output. */
@property (copy, nonatomic) NSString *name;

/** A block which defines a piece of behaviour within a system. */
@property (copy, nonatomic) void(^block)(void);

/** The states in which an example can exist.
 
 An example is considered pending until a block is assigned to which, at which time it is considered ready. It is then considered to be executed once execute has been invoked. The possible values are:
 
 - SPCExampleStatePending
 - SPCExampleStateReady
 - SPCExampleStateExecuted
 */
@property (nonatomic) SPCExampleState state;

/** The group which this example has been added to. A group is assigned to the example when [SPCGroup addGroup:] is called. */
@property (weak, nonatomic) SPCGroup *parentGroup;

@end
