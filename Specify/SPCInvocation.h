//
//  SPCInvocation.h
//  Specify
//
//  Created by Ryan Davies on 15/01/2013.
//  Copyright (c) 2013 Ryan Davies. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SPCExample;

/** A subclass of NSInvocation which allows for the execution of examples rather than selectors.
 
 @note This is necessary due to the manner in which SenTestCase formats its tests: each test case accepts an instance of NSInvocation and sets its target to the test case itself. In order to run examples, instances of NSInvocation are swapped out for those of SPCInvocation. It is not possible to use NSInvocation to call -execute on a SPCExample because SenTestCase sets the target of the invocation when setInvocation: is invoked.
 */
@interface SPCInvocation : NSInvocation

/** The example to be executed. */
@property (strong, nonatomic) SPCExample *example;

/** Creates an instance of SPCInvocation and calls -setExample: on it with the given SPCExample.
 @note The example is created with a void method signature.
 @param example The SPCExample instance to assign to the invocation.
 @return An instance of SPCInvocation.
 */
+ (instancetype)invocationWithExample:(SPCExample *)example;

/** Calls [SPCExample execute] for the example. */
- (void)invoke;

@end
