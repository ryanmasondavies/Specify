//
//  BHVTestHelper.h
//  Beehive
//
//  Created by Ryan Davies on 21/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVSpec.h"
@class BHVContext;

NSArray * stackOfContexts(NSUInteger count);
NSArray * examplesByAddingToContext(BHVContext *context, BOOL markAsExecuted);
NSArray * hooksByAddingToContext(BHVContext *context);

@interface BHVTestSpec1 : BHVSpec
@end

@interface BHVTestSpec2 : BHVSpec
@end

@interface BHVTestSpec3 : BHVSpec
@end
