//
//  BHVSuiteRegistry.h
//  Beehive
//
//  Created by Ryan Davies on 13/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BHVSuite;

@interface BHVSuiteRegistry : NSObject

+ (id)sharedRegistry;

- (void)registerSuite:(BHVSuite *)suite forClass:(Class)klass;
- (BHVSuite *)suiteForClass:(Class)klass;

@end
