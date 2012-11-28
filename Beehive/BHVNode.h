//
//  BHVNode.h
//  Beehive
//
//  Created by Ryan Davies on 27/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BHVNodeVisitor.h"

@interface BHVNode : NSObject

- (void)accept:(id <BHVNodeVisitor>)visitor;

@end
