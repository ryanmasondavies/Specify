//
//  BHVRunningTests.c
//  Beehive
//
//  Created by Ryan Davies on 11/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVTestHelper.h"

SenTestSuiteRun *RunSpecClass(Class testClass)
{
    [SenTestObserver suspendObservation];
    SenTestSuiteRun *result = (id)[(SenTestSuite *)[SenTestSuite testSuiteForTestCaseClass:testClass] run];
    [SenTestObserver resumeObservation];
    return result;
}
