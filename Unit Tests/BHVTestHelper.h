//
//  BHVTestHelper.h
//  Behave
//
//  Created by Ryan Davies on 21/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVSpec.h"
@class BHVContext;

extern Class recordedSpec;

NSArray * stackOfContexts(NSUInteger count);
NSArray * examplesByAddingToContext(BHVContext *context, NSUInteger number, BOOL markAsExecuted);
NSArray * hooksByAddingToContext(BHVContext *context, NSUInteger number);
BHVContext * BHVCreateBranchedStack(NSArray *nodes);

@interface BHVTestSpec1 : BHVSpec
@end

@interface BHVTestSpec2 : BHVSpec
@end

@interface BHVTestSpec3 : BHVSpec
@end

@interface BHVCurrentSpecRecorderSpec : BHVSpec
@end
