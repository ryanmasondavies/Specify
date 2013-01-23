//
//  BHVAfterEachHook.h
//  Behave
//
//  Created by Ryan Davies on 15/01/2013.
//  Copyright (c) 2013 Ryan Davies. All rights reserved.
//

#import "BHVHook.h"

/** A hook which is executed after every example. */
@interface BHVAfterEachHook : BHVHook

/**
 @param example The example to evaluate, ignored in this case.
 @return Returns NO, indicating that this hook should not be executed before the example. */
- (BOOL)isExecutableBeforeExample:(BHVExample *)example;

/**
 @param example The example to evaluate, ignored in this case.
 @return Returns YES, indicating that this hook should be executed after the example. */
- (BOOL)isExecutableAfterExample:(BHVExample *)example;

@end
