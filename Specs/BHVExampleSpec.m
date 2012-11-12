//
//  BHVExampleTests.m
//  Beehive
//
//  Created by Ryan Davies on 10/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVSpec.h"
#import "BHVExample.h"

@interface BHVExampleSpec : BHVSpec
@end

@implementation BHVExampleSpec

+ (void)defineBehaviour
{
    __block NSUInteger numberOfExecutions = 0;
    
    it(@"should only run examples once", ^{
        numberOfExecutions ++;
        if (numberOfExecutions != 1)
            [NSException raise:NSInternalInconsistencyException format:@"Expected example to run only once."];
    });
}

@end
