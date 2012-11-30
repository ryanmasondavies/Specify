//
//  BHVExample.h
//  Beehive
//
//  Created by Ryan Davies on 27/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVExecutableNode.h"

@interface BHVExample : BHVExecutableNode <BHVNodeVisitor>

- (NSString *)fullName;

@end
