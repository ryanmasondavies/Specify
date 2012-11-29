//
//  BHVItFunction.m
//  Beehive
//
//  Created by Ryan Davies on 29/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVItFunction.h"
#import "BHVSpec.h"
#import "BHVSuiteRegistry.h"
#import "BHVSuite.h"
#import "BHVExample.h"

void it(NSString *name, void(^block)(void))
{
    // Build an example from the attributes:
    BHVExample *example = [[BHVExample alloc] init];
    [example setName:name];
    [example setBlock:block];
    
    // Add the example to the suite for the spec being loaded:
    [[BHVSuiteRegistry suiteForClass:[BHVSpec currentSpec]] addNode:example];
}
