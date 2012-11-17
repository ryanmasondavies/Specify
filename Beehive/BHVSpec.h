//
//  BHVSpec.h
//  Beehive
//
//  Created by Ryan Davies on 11/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

@class BHVExample;

@interface BHVSpec : SenTestCase
- (void)loadExamples;
- (BHVExample *)currentExample;
@end
