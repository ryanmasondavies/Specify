//
//  BHVContextFunction.m
//  Beehive
//
//  Created by Ryan Davies on 21/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVContextFunction.h"
#import "BHVContext.h"
#import "BHVSuiteRegistry.h"
#import "BHVSuite.h"

void context(NSString *name, BHVImplementationBlock implementation)
{
    // Create a context:
    BHVContext *context = [[BHVContext alloc] init];
    [context setName:name];
    [context setImplementation:implementation];
    
    // Add examples to the context using the unlocked suites:
    NSArray *suites = [[BHVSuiteRegistry sharedRegistry] unlockedSuites];
    [suites makeObjectsPerformSelector:@selector(processContext:) withObject:context];
}
