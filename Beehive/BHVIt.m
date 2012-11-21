//
//  BHVIt.m
//  Beehive
//
//  Created by Ryan Davies on 21/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVIt.h"
#import "BHVExample.h"
#import "BHVSuiteRegistry.h"
#import "BHVSuite.h"

void it(NSString *name, BHVImplementationBlock implementation)
{
    // Create an example with the name and description:
    BHVExample *example = [[BHVExample alloc] init];
    [example setName:name];
    [example setImplementation:implementation];
    
    // Add example to each unlocked suite in the registry:
    NSArray *suites = [[BHVSuiteRegistry sharedRegistry] unlockedSuites];
    [suites enumerateObjectsUsingBlock:^(BHVSuite *suite, NSUInteger idx, BOOL *stop) {
        [suite addExample:example];
    }];
}
