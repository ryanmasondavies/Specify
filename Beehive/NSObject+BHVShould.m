//
//  NSObject+BHVShould.m
//  Beehive
//
//  Created by Ryan Davies on 14/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "NSObject+BHVShould.h"
#import "BHVExpectation.h"

@implementation NSObject (BHVShould)

- (id)should
{
    return [[BHVExpectation alloc] initWithSubject:self];
}

@end
