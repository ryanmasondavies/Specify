//
//  BHVInvocation.h
//  Behave
//
//  Created by Ryan Davies on 15/01/2013.
//  Copyright (c) 2013 Ryan Davies. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BHVExample;

/** A subclass of NSInvocation which allows for the execution of examples rather than selectors.
 
 @note This is necessary due to the manner in which SenTestCase formats its tests: each test case accepts an instance of NSInvocation and sets its target to the test case itself. In order to run examples, instances of NSInvocation are swapped out for those of BHVInvocation. It is not possible to use NSInvocation to call -execute on a BHVExample because SenTestCase sets the target of the invocation when setInvocation: is invoked.
 */
@interface BHVInvocation : NSInvocation

/** The example to be executed. */
@property (strong, nonatomic) BHVExample *example;

/** Creates an instance of BHVInvocation and calls -setExample: on it with the given BHVExample.
 @note The example is created with a void method signature.
 @param example The BHVExample instance to assign to the invocation.
 @return An instance of BHVInvocation.
 */
+ (instancetype)invocationWithExample:(BHVExample *)example;

/** Calls [BHVExample execute] for the example. */
- (void)invoke;

@end
