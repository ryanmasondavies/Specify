//
//  BHVSuite.h
//  Beehive
//
//  Created by Ryan Davies on 11/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVBlockTypes.h"

@class BHVExample;

@interface BHVSuite : NSObject

+ (id)sharedSuite;

- (NSArray *)invocations;
- (void)addExample:(BHVExample *)example;

@end

#pragma mark Defining behaviour

void example(NSString *description, BHVVoidBlock block);
void it(NSString *description, BHVVoidBlock block);