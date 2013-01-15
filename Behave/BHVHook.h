//
//  BHVHook.h
//  Behave
//
//  Created by Ryan Davies on 15/01/2013.
//  Copyright (c) 2013 Ryan Davies. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BHVExample, BHVGroup;

@interface BHVHook : NSObject

- (BOOL)isExecutableBeforeExample:(BHVExample *)example;
- (BOOL)isExecutableAfterExample:(BHVExample *)example;

- (void)execute;

@property (weak, nonatomic) BHVGroup *parentGroup;
@property (copy, nonatomic) void(^block)(void);

@end
