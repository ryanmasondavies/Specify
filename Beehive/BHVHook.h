//
//  BHVHook.h
//  Beehive
//
//  Created by Ryan Davies on 29/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVNode.h"

/*
 `name` is set to either "before" or "after", indicating __when__ the hook is executed in relation to examples.
 */

@interface BHVHook : BHVNode
@property (nonatomic, copy) void(^block)(void);
@property (nonatomic, getter=isExecuted) BOOL executed;

- (void)execute;

@end
