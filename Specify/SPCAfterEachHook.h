//
//  SPCAfterEachHook.h
//  Specify
//
//  Created by Ryan Davies on 15/01/2013.
//  Copyright (c) 2013 Ryan Davies. All rights reserved.
//

#import "SPCHook.h"

/** A hook which is executed after every example. */
@interface SPCAfterEachHook : SPCHook

/**
 @param example The example to evaluate, ignored in this case.
 @return Returns NO, indicating that this hook should not be executed before the example. */
- (BOOL)isExecutableBeforeExample:(SPCExample *)example;

/**
 @param example The example to evaluate, ignored in this case.
 @return Returns YES, indicating that this hook should be executed after the example. */
- (BOOL)isExecutableAfterExample:(SPCExample *)example;

@end
