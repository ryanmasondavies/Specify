//
//  BHVMatcherRegistry.h
//  Beehive
//
//  Created by Ryan Davies on 14/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BHVMatcherRegistry : NSObject
@property (nonatomic, strong) NSArray *registeredClasses;

+ (id)sharedRegistry;

- (Class)classWhoseInstancesRespondToSelector:(SEL)selector;

@end
