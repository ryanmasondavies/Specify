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

typedef NS_ENUM(NSInteger, BHVHookFrequency) {
    BHVHookFrequencyEach,
    BHVHookFrequencyAll
};

/*
 `position` is set to either "before" or "after", indicating __when__ the hook is executed in relation to examples.
 `frequency` is set to either "all" or "each", indicating __how often__ the hook is executed in relation to examples.
 */

@interface BHVHook : BHVExecutableNode <BHVNodeVisitor>
@property (nonatomic, strong) BHVExample *example;
@property (nonatomic) BHVHookPosition position;
@property (nonatomic) BHVHookFrequency frequency;
- (id)initWithPosition:(BHVHookPosition)position frequency:(BHVHookFrequency)frequency;
@end
