//
//  BHVBuilder.h
//  Behave
//
//  Created by Ryan Davies on 15/01/2013.
//  Copyright (c) 2013 Ryan Davies. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BHVGroup, BHVExample, BHVHook;

@interface BHVBuilder : NSObject

- (BHVGroup *)rootGroup;

- (void)enterGroup:(BHVGroup *)group;
- (void)leaveGroup;

- (void)addExample:(BHVExample *)example;
- (void)addHook:(BHVHook *)hook;

@end
