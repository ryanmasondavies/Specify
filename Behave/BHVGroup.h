//
//  BHVGroup.h
//  Behave
//
//  Created by Ryan Davies on 30/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BHVExample, BHVHook;

@interface BHVGroup : NSObject

- (instancetype)initWithName:(NSString *)name;

- (void)addGroup:(BHVGroup *)group;
- (void)addExample:(BHVExample *)example;
- (void)addHook:(BHVHook *)hook;

@property (copy,   nonatomic) NSString   *name;
@property (strong, nonatomic) NSArray    *groups;
@property (strong, nonatomic) NSArray    *examples;
@property (strong, nonatomic) NSArray    *hooks;
@property (weak,   nonatomic) BHVGroup *parentGroup;

@end
