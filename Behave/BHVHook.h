//
//  BHVHook.h
//  Behave
//
//  Created by Ryan Davies on 30/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BHVContext;

typedef NS_ENUM(NSInteger, BHVHookScope) {
    BHVHookScopeBeforeAll = 0,
    BHVHookScopeBeforeEach,
    BHVHookScopeAfterEach,
    BHVHookScopeAfterAll
};

@interface BHVHook : NSObject

- (instancetype)initWithScope:(BHVHookScope)flavor;

@property (nonatomic) BHVHookScope flavor;
@property (weak, nonatomic) BHVContext *parentContext;
@property (copy, nonatomic) void(^block)(void);

@end
