//
//  BHVInvocation.h
//  Behave
//
//  Created by Ryan Davies on 15/01/2013.
//  Copyright (c) 2013 Ryan Davies. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BHVExample;

@interface BHVInvocation : NSInvocation
@property (strong, nonatomic) BHVExample *example;
+ (instancetype)invocationWithExample:(BHVExample *)example;
@end
