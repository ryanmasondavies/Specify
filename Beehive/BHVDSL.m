//
//  BHVDSL.m
//  Beehive
//
//  Created by Ryan Davies on 30/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVDSL.h"
#import "BHVSpec.h"
#import "BHVSuite.h"
#import "BHVContext.h"
#import "BHVHook.h"
#import "BHVExample.h"

@interface BHVDSL ()
+ (void)makeExampleWithName:(NSString *)name block:(void(^)(void))block;
+ (void)makeContextWithName:(NSString *)name block:(void(^)(void))block;
+ (void)makeHookWithPosition:(BHVHookPosition)position frequency:(BHVHookFrequency)frequency block:(void(^)(void))block;
@end

@implementation BHVDSL

+ (void)makeExampleWithName:(NSString *)name block:(void(^)(void))block
{
    // Build an example from the attributes:
    BHVExample *example = [[BHVExample alloc] init];
    [example setName:name];
    [example setBlock:block];
    
    // Add the example to the suite for the spec being loaded:
    [[[BHVSpec currentSpec] suite] addNode:example];
}

+ (void)makeContextWithName:(NSString *)name block:(void(^)(void))block
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

+ (void)makeHookWithPosition:(BHVHookPosition)position frequency:(BHVHookFrequency)frequency block:(void(^)(void))block
{
    // Build a hook from the attributes:
    BHVHook *hook = [[BHVHook alloc] init];
    [hook setPosition:position];
    [hook setFrequency:frequency];
    [hook setBlock:block];
    
    // Add the hook to the suite for the spec being loaded:
    [[[BHVSpec currentSpec] suite] addNode:hook];
}

@end

void it(NSString *name, void(^block)(void))
{
    [BHVDSL makeExampleWithName:name block:block];
}

void context(NSString *name, void(^block)(void))
{
    [BHVDSL makeContextWithName:name block:block];
}

void describe(NSString *name, void(^block)(void))
{
    [BHVDSL makeContextWithName:name block:block];
}

void beforeEach(void(^block)(void))
{
    [BHVDSL makeHookWithPosition:BHVHookPositionBefore frequency:BHVHookFrequencyEach block:block];
}

void afterEach(void(^block)(void))
{
    [BHVDSL makeHookWithPosition:BHVHookPositionAfter frequency:BHVHookFrequencyEach block:block];
}

void beforeAll(void(^block)(void))
{
    [BHVDSL makeHookWithPosition:BHVHookPositionBefore frequency:BHVHookFrequencyAll block:block];
}

void afterAll(void(^block)(void))
{
    [BHVDSL makeHookWithPosition:BHVHookPositionAfter frequency:BHVHookFrequencyAll block:block];
}
