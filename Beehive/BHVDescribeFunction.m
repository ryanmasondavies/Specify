//
//  BHVDescribeFunction.m
//  Beehive
//
//  Created by Ryan Davies on 29/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVDescribeFunction.h"
#import "BHVContextFunction.h"

void describe(NSString *name, void(^block)(void))
{
    context(name, block);
}
