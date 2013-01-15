//
//  BHVExample.h
//  Behave
//
//  Created by Ryan Davies on 30/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVNode.h"
@class BHVGroup;

typedef NS_ENUM(NSInteger, BHVExampleState) {
    BHVExampleStatePending,
    BHVExampleStateReady,
    BHVExampleStateExecuted
};

@interface BHVExample : BHVNode

- (void)execute;

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) void(^block)(void);
@property (nonatomic) BHVExampleState state;
@end
