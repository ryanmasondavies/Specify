//
//  BHVExample.h
//  Beehive
//
//  Created by Ryan Davies on 27/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVNode.h"

@interface BHVExample : BHVNode
@property (nonatomic, copy) void(^block)(void);
@property (nonatomic, getter=isExecuted) BOOL executed;

- (NSString *)fullName;
- (void)execute;

@end
