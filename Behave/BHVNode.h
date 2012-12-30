//
//  BHVNode.h
//  Behave
//
//  Created by Ryan Davies on 27/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BHVContext;

@interface BHVNode : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, weak) BHVContext *context;

- (BOOL)isContext;
- (BOOL)isExample;
- (BOOL)isHook;

@end
