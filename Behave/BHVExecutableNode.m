//
//  BHVExecutableNode.m
//  Behave
//
//  Created by Ryan Davies on 30/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVExecutableNode.h"

@implementation BHVExecutableNode

- (void)execute
{
    if ([self block])
        self.block();
    
    self.executed = YES;
}

@end
