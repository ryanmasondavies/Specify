//
//  SPCExample.h
//  Specify
//
//  Created by Ryan Davies on 30/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Inline/Inline.h>
@class INLGroup;

typedef NS_ENUM(NSInteger, SPCExampleState) {
    SPCExampleStatePending,
    SPCExampleStateReady,
    SPCExampleStateExecuted
};

/** An example which defines a single piece of behaviour within a system.
 
 An example has a name, a block, and exists within a group identified by parentGroup. Hooks in the parent and subsequent parent groups are handled in execute, and are used to provide an environment in which the example is defined. */
@interface SPCExample : INLTest

/** Executes an example and its hooks. */
- (void)execute;

/** The description for the example, made by accumulating the labels of parent groups and concatenating them with the example's label. */
- (NSString *)description;

/** A block which defines a piece of behaviour within a system. */
@property (copy, nonatomic) void(^block)(void);

/** The states in which an example can exist.
 
 An example is considered pending until a block is assigned to which, at which time it is considered ready. It is then considered to be executed once execute has been invoked. The possible values are:
 
 - SPCExampleStatePending
 - SPCExampleStateReady
 - SPCExampleStateExecuted
 */
@property (nonatomic) SPCExampleState state;

@end
