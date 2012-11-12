//
//  BHVMacros.h
//  Beehive
//
//  Created by Ryan Davies on 12/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#define SpecBegin(name) \
@interface name##Spec : BHVSpec \
@end \
\
@implementation name##Spec \
\
+ (void)defineBehaviour \
{ \

#define SpecEnd \
} \
@end
