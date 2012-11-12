//
//  BHVInvocation.h
//  Beehive
//
//  Created by Ryan Davies on 12/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

@class BHVExample;

@interface BHVInvocation : NSInvocation
@property (nonatomic, strong) BHVExample *example;
@end
