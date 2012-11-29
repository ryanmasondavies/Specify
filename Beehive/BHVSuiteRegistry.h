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

+ (BHVSuite *)suiteForClass:(Class)klass;
+ (void)registerSuite:(BHVSuite *)suite forClass:(Class)klass;
+ (void)removeAllSuites;

@end
