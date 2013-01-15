//
//  BHVTestHelper.h
//  Behave
//
//  Created by Ryan Davies on 02/01/2013.
//  Copyright (c) 2013 Ryan Davies. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>
#import "BHVSpecification.h"
#import "BHVGroup.h"
#import "BHVExample.h"
#import "BHVBeforeEachHook.h"
#import "BHVAfterEachHook.h"

@interface BHVTestSpecification : BHVSpecification
@end

@interface BHVSpecificationWithThreeExamples : BHVSpecification
@end

@interface BHVSpecificationWithUnorderedNestedExamples : BHVSpecification
@end

@interface BHVSpecificationWithHooks : BHVSpecification
@end
