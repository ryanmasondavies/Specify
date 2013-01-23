//
//  SPCDSL.m
//  Specify
//
//  Created by Ryan Davies on 15/01/2013.
//  Copyright (c) 2013 Ryan Davies. All rights reserved.
//

#import "SPCDSL.h"
#import "SPCSpecification.h"
#import "SPCBuilder.h"
#import "SPCGroup.h"
#import "SPCExample.h"
#import "SPCBeforeEachHook.h"
#import "SPCAfterEachHook.h"

void it(NSString *name, void(^block)(void))
{
    SPCExample *example = [[SPCExample alloc] init];
    [example setName:name];
    [example setBlock:block];
    [[[SPCSpecification currentSpecification] builder] addExample:example];
}

void context(NSString *name, void(^block)(void))
{
    // Create group:
    SPCGroup *group = [[SPCGroup alloc] initWithName:name];
    
    // Add group and its contents to the specification:
    [[[SPCSpecification currentSpecification] builder] enterGroup:group];
    block();
    [[[SPCSpecification currentSpecification] builder] leaveGroup];
}

void describe(NSString *name, void(^block)(void))
{
    context(name, block);
}

void when(NSString *name, void(^block)(void))
{
    context([NSString stringWithFormat:@"when %@", name], block);
}

void before(void(^block)(void))
{
    beforeEach(block);
}

void beforeEach(void(^block)(void))
{
    SPCHook *hook = [[SPCBeforeEachHook alloc] init];
    [hook setBlock:block];
    [[[SPCSpecification currentSpecification] builder] addHook:hook];
}

void after(void(^block)(void))
{
    afterEach(block);
}

void afterEach(void(^block)(void))
{
    SPCHook *hook = [[SPCAfterEachHook alloc] init];
    [hook setBlock:block];
    [[[SPCSpecification currentSpecification] builder] addHook:hook];
}
