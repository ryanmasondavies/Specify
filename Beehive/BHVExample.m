//
//  BHVExample.m
//  Beehive
//
//  Created by Ryan Davies on 27/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVExample.h"

@implementation BHVExample

- (void)accept:(id <BHVNodeVisitor>)visitor
{
    [visitor visitExample:self];
}

- (void)execute
{
    self.executed = YES;
}

@end
