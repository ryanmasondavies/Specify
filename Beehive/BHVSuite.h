//
//  BHVSuite.h
//  Beehive
//
//  Created by Ryan Davies on 11/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVContext.h"

@interface BHVSuite : BHVContext

- (void)enterContext:(BHVContext *)context;
- (void)leaveContext;

@end
