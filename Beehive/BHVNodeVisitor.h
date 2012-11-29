//
//  BHVNodeVisitor.h
//  Beehive
//
//  Created by Ryan Davies on 28/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BHVHook, BHVExample;

@protocol BHVNodeVisitor <NSObject>

- (void)visitHook:(BHVHook *)hook;
- (void)visitExample:(BHVExample *)example;

@end
