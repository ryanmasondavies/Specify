//
//  SPCExample.m
//  Specify
//
//  Created by Ryan Davies on 30/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "SPCExample.h"
#import "INLGroup.h"

@implementation SPCExample

- (NSString *)description
{
    NSMutableArray *labels = [NSMutableArray array];
    INLGroup *group = [self parent];
    while (group != nil) {
        if ([group label]) [labels insertObject:[group label] atIndex:0];
        group = [group parent];
    }
    [labels addObject:[self label]];
    return [labels componentsJoinedByString:@" "];
}

@end
