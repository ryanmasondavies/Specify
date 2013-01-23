//
//  SPCBeforeEachHook.h
//  Specify
//
//  Created by Ryan Davies on 30/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "SPCHook.h"

/** A hook which is executed before every example. */
@interface SPCBeforeEachHook : SPCHook

/**
 @param example The example to evaluate, ignored in this case.
 @return Returns YES, indicating that this hook should be executed before the example. */
- (BOOL)isExecutableBeforeExample:(SPCExample *)example;

/**
 @param example The example to evaluate, ignored in this case.
 @return Returns NO, indicating that this hook should not be executed after the example. */
- (BOOL)isExecutableAfterExample:(SPCExample *)example;

@end
