//
//  BHVMatcher.m
//  Beehive
//
//  Created by Ryan Davies on 14/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVMatcher.h"
#import "BHVMatcherRegistry.h"

@implementation BHVMatcher

- (id)initWithSubject:(id)subject
{
    if (self = [super init])
        self.subject = subject;
    
    return self;
}

@end
