//
//  BHVBeforeEachHook.h
//  Behave
//
//  Created by Ryan Davies on 30/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVHook.h"

/** A hook which is executed before every example. */
@interface BHVBeforeEachHook : BHVHook

/**
 @param example The example to evaluate, ignored in this case.
 @return Returns YES, indicating that this hook should be executed before the example. */
- (BOOL)isExecutableBeforeExample:(BHVExample *)example;

/**
 @param example The example to evaluate, ignored in this case.
 @return Returns NO, indicating that this hook should not be executed after the example. */
- (BOOL)isExecutableAfterExample:(BHVExample *)example;

@end
