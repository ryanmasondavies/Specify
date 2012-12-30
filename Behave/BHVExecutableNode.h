//
//  BHVExecutableNode.h
//  Behave
//
//  Created by Ryan Davies on 30/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVNode.h"

@interface BHVExecutableNode : BHVNode
@property (nonatomic, copy) void(^block)(void);
@property (nonatomic, getter=isExecuted) BOOL executed;

- (void)execute;

@end
