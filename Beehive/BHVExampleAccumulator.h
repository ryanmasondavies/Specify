//
//  BHVExampleAccumulator.h
//  Beehive
//
//  Created by Ryan Davies on 28/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BHVNodeVisitor.h"
@class BHVNode;

@interface BHVExampleAccumulator : NSObject <BHVNodeVisitor>

- (id)initWithNode:(BHVNode *)node;
- (NSArray *)examples;

@end
