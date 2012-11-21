//
//  BHVSuite.h
//  Beehive
//
//  Created by Ryan Davies on 11/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

@class BHVExample;

@interface BHVSuite : NSObject
@property (nonatomic, getter=isLocked) BOOL locked;

- (void)lock;
- (void)unlock;

- (void)addExample:(BHVExample *)example;

- (BHVExample *)exampleAtIndex:(NSUInteger)index;
- (NSUInteger)numberOfExamples;

- (NSArray *)compiledExamples;

@end
