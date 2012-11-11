//
//  BHVSpec.h
//  Beehive
//
//  Created by Ryan Davies on 11/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVBlockTypes.h"

@class BHVExample;

#define SpecBegin(className) \
@interface className##Spec : BHVSpec; @end \
@implementation className##Spec \
\
+ (void)defineBehaviour \
{ \

#define SpecEnd \
} \
@end

void example(NSString *description, BHVVoidBlock block);
void it(NSString *description, BHVVoidBlock block);

@interface BHVSpec : SenTestCase
+ (void)defineBehaviour;
@end
