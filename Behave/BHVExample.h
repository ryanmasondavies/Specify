//
//  BHVExample.h
//  Behave
//
//  Created by Ryan Davies on 30/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BHVContext;

@interface BHVExample : NSObject
@property (copy, nonatomic) NSString   *name;
@property (weak, nonatomic) BHVContext *parentContext;

- (void)perform;

@end
