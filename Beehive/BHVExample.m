//
//  BHVExample.m
//  Beehive
//
//  Created by Ryan Davies on 10/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVExample.h"

@implementation BHVExample

- (void)execute
{
    self.block();
    [[self delegate] exampleDidExecute:self];
}

@end

