//
//  BHVHook.h
//  Beehive
//
//  Created by Ryan Davies on 29/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVExecutableNode.h"

typedef NS_ENUM(NSInteger, BHVHookPosition) {
    BHVHookPositionBefore,
    BHVHookPositionAfter
};

/*
 `position` is set to either "before" or "after", indicating __when__ the hook is executed in relation to examples.
 */

@interface BHVHook : BHVExecutableNode
@property (nonatomic) BHVHookPosition position;
@end
