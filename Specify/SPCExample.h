//
//  SPCExample.h
//  Specify
//
//  Created by Ryan Davies on 30/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Inline/Inline.h>

/** An example which defines a single piece of behaviour within a system.
 
 An example has a name, a block, and exists within a group identified by parentGroup. Hooks in the parent and subsequent parent groups are handled in execute, and are used to provide an environment in which the example is defined. */
@interface SPCExample : INLBlockTest

/** The description for the example, made by accumulating the labels of parent groups and concatenating them with the example's label. */
- (NSString *)description;

@end
