//
//  BHVDSL.m
//  Behave
//
//  Created by Ryan Davies on 15/01/2013.
//  Copyright (c) 2013 Ryan Davies. All rights reserved.
//

#import "BHVDSL.h"
#import "BHVSpecification.h"
#import "BHVBuilder.h"
#import "BHVGroup.h"
#import "BHVExample.h"
#import "BHVBeforeEachHook.h"
#import "BHVAfterEachHook.h"

void it(NSString *name, void(^block)(void))
{
    BHVExample *example = [[BHVExample alloc] init];
    [example setName:name];
    [example setBlock:block];
    [[[BHVSpecification currentSpecification] builder] addExample:example];
}

void context(NSString *name, void(^block)(void))
{
    // Create group:
    BHVGroup *group = [[BHVGroup alloc] initWithName:name];
    
    // Add group and its contents to the specification:
    [[[BHVSpecification currentSpecification] builder] enterGroup:group];
    block();
    [[[BHVSpecification currentSpecification] builder] leaveGroup];
}

void describe(NSString *name, void(^block)(void))
{
    context(name, block);
}

void beforeEach(void(^block)(void))
{
    BHVHook *hook = [[BHVBeforeEachHook alloc] init];
    [hook setBlock:block];
    [[[BHVSpecification currentSpecification] builder] addHook:hook];
}

void afterEach(void(^block)(void))
{
    BHVHook *hook = [[BHVAfterEachHook alloc] init];
    [hook setBlock:block];
    [[[BHVSpecification currentSpecification] builder] addHook:hook];
}
