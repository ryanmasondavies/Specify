//
//  BHVExample.h
//  Behave
//
//  Created by Ryan Davies on 30/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVNode.h"
@class BHVGroup;

@interface BHVExample : BHVNode

- (instancetype)initWithName:(NSString *)name block:(void(^)(void))block;

- (void)execute;

@property (copy, nonatomic) NSString   *name;
@property (nonatomic, getter = isExecuted) BOOL executed;
@property (copy, nonatomic) void(^block)(void);
@end
