//
//  BHVContextFunction.m
//  Beehive
//
//  Created by Ryan Davies on 29/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVContextFunction.h"
#import "BHVSpec.h"
#import "BHVSuite.h"
#import "BHVContext.h"

void context(NSString *name, void(^block)(void))
{
    // Retrieve the suite for the current spec:
    BHVSuite *suite = [[BHVSpec currentSpec] suite];
    
    // Build an context:
    BHVContext *context = [[BHVContext alloc] init];
    [context setName:name];
    
    // Enter the context:
    [suite enterContext:context];
    block();
    [suite leaveContext];
    
    // Add the example to the suite for the spec being loaded:
    [suite addNode:context];
}
