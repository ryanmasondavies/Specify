//
//  BHVEqualityMatcher.m
//  Beehive
//
//  Created by Ryan Davies on 14/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVEqualityMatcher.h"
#import "BHVMatcherRegistry.h"

@implementation BHVEqualityMatcher

- (BOOL)beEqualTo:(id)object
{
    return [[self subject] isEqual:object];
}

@end
