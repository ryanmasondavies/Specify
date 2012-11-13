//
//  BHVExample.m
//  Beehive
//
//  Created by Ryan Davies on 10/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVExample.h"

@implementation BHVExample

+ (id)exampleWithDescription:(NSString *)description implementation:(BHVVoidBlock)implementation
{
    return [[self alloc] initWithDescription:description implementation:implementation];
}

- (id)initWithDescription:(NSString *)description implementation:(BHVVoidBlock)implementation
{
    if (self = [super init]) {
        self.description = description;
        self.implementation = implementation;
    }
    
    return self;
}

- (void)execute
{
    self.implementation();
}

@end

