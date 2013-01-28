//
//  SPCTestHelper.h
//  Specify
//
//  Created by Ryan Davies on 02/01/2013.
//  Copyright (c) 2013 Ryan Davies. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>
#import "SPCDSL.h"
#import "SPCSpecification.h"
#import "SPCBuilder.h"
#import "SPCGroup.h"
#import "SPCExample.h"
#import "SPCBeforeEachHook.h"
#import "SPCAfterEachHook.h"

@interface SPCTestSpecification : SPCSpecification
@end

@interface SPCSpecificationA : SPCSpecification
@end

@interface SPCSpecificationB : SPCSpecification
@end

@interface SPCSpecificationWithThreeExamples : SPCSpecification
@end

@interface SPCSpecificationWithUnorderedNestedExamples : SPCSpecification
@end

@interface SPCSpecificationWithHooks : SPCSpecification
@end
