//
//  BHVContext.h
//  Behave
//
//  Created by Ryan Davies on 30/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BHVExample, BHVHook;

@interface BHVContext : NSObject

- (void)addContext:(BHVContext *)context;
- (void)addExample:(BHVExample *)example;
- (void)addHook:(BHVHook *)hook;

@property (copy,   nonatomic) NSString   *name;
@property (strong, nonatomic) NSArray    *contexts;
@property (strong, nonatomic) NSArray    *examples;
@property (strong, nonatomic) NSArray    *hooks;
@property (weak,   nonatomic) BHVContext *parentContext;

@end
