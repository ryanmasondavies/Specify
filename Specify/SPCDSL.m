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
#import "SPCExample.h"

void it(NSString *label, void(^block)(void))
{
    SPCExample *example = [[SPCExample alloc] init];
    [example setLabel:label];
    [example setBlock:block];
    [(SPCBuilder *)[[SPCSpecification currentSpecification] builder] addExample:example];
}

void context(NSString *label, void(^block)(void))
{
    // Create group:
    INLGroup *group = [[INLGroup alloc] init];
    [group setLabel:label];
    
    // Add group and its contents to the specification:
    [(SPCBuilder *)[[SPCSpecification currentSpecification] builder] enterGroup:group];
    block();
    [(SPCBuilder *)[[SPCSpecification currentSpecification] builder] leaveGroup];
}

void describe(NSString *label, void(^block)(void))
{
    context(label, block);
}

void when(NSString *label, void(^block)(void))
{
    context([NSString stringWithFormat:@"when %@", label], block);
}

void before(void(^block)(void))
{
    beforeEach(block);
}

void beforeEach(void(^block)(void))
{
    INLBlockHook *hook = [[INLBlockHook alloc] init];
    [hook setPlacement:INLHookPlacementBefore];
    [hook setBlock:block];
    [(SPCBuilder *)[[SPCSpecification currentSpecification] builder] addHook:hook];
}

void after(void(^block)(void))
{
    afterEach(block);
}

void afterEach(void(^block)(void))
{
    INLBlockHook *hook = [[INLBlockHook alloc] init];
    [hook setPlacement:INLHookPlacementAfter];
    [hook setBlock:block];
    [(SPCBuilder *)[[SPCSpecification currentSpecification] builder] addHook:hook];
}
