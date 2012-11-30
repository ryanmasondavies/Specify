//
//  BHVAfterEachFunction.m
//  Beehive
//
//  Created by Ryan Davies on 30/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVAfterEachFunction.h"
#import "BHVSpec.h"
#import "BHVSuite.h"
#import "BHVHook.h"

void afterEach(void(^block)(void))
{
    // Build a hook from the attributes:
    BHVHook *hook = [[BHVHook alloc] init];
    [hook setPosition:BHVHookPositionAfter];
    [hook setBlock:block];
    
    // Add the hook to the suite for the spec being loaded:
    [[[BHVSpec currentSpec] suite] addNode:hook];
}
