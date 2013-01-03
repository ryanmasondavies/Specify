//
//  BHVHook.h
//  Behave
//
//  Created by Ryan Davies on 30/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BHVContext;

typedef NS_ENUM(NSInteger, BHVHookFlavor) {
    BHVHookFlavorBeforeAll = 0,
    BHVHookFlavorBeforeEach,
    BHVHookFlavorAfterEach,
    BHVHookFlavorAfterAll
};

@interface BHVHook : NSObject

- (instancetype)initWithFlavor:(BHVHookFlavor)flavor;

@property (nonatomic) BHVHookFlavor flavor;
@property (weak, nonatomic) BHVContext *parentContext;
@property (copy, nonatomic) void(^block)(void);

@end
