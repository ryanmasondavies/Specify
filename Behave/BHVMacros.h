//
//  BHVMacros.h
//  Behave
//
//  Created by Ryan Davies on 22/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#define SpecBegin(class) \
@interface class##Spec : BHVSpec \
@end \
@implementation class##Spec \
- (void)loadExamples \
{

#define SpecEnd \
} \
@end
