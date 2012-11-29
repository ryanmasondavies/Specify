//
//  BHVBeforeFunction.m
//  Beehive
//
//  Created by Ryan Davies on 29/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVBeforeFunction.h"
#import "BHVSpec.h"
#import "BHVSuite.h"
#import "BHVHook.h"

void beforeEach(void(^block)(void))
{
    // Build a hook from the attributes:
    BHVHook *hook = [[BHVHook alloc] init];
    [hook setBlock:block];
    
    // Add the hook to the suite for the spec being loaded:
    [[[BHVSpec currentSpec] suite] addNode:hook];
}
