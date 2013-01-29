//
//  SPCHook.h
//  Specify
//
//  Created by Ryan Davies on 15/01/2013.
//  Copyright (c) 2013 Ryan Davies. All rights reserved.
//

#import <Inline/Inline.h>

/** Extends INLHook to invoke a block [SPCHook execute]. */
@interface SPCHook : INLHook

/** Invokes block. */
- (void)execute;

/** The block which contains the implementation of the hook. */
@property (copy, nonatomic) void(^block)(void);

@end
