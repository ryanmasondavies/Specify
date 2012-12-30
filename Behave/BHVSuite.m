//
//  BHVSuite.m
//  Behave
//
//  Created by Ryan Davies on 11/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVSuite.h"
#import "BHVNode.h"
#import "BHVContext.h"

@interface BHVSuite ()
@property (nonatomic, strong) NSMutableArray *contextStack;
@end

@implementation BHVSuite

- (id)init
{
    if (self = [super init]) {
        self.contextStack = [NSMutableArray array];
    }
    return self;
}

- (void)addNode:(BHVNode *)node
{
    BHVContext *context = [[self contextStack] lastObject];
    if (context) {
        [context addNode:node];
    } else {
        [super addNode:node];
    }
}

- (void)enterContext:(BHVContext *)context
{
    [self.contextStack addObject:context];
}

- (void)leaveContext
{
    [self.contextStack removeLastObject];
}

@end
