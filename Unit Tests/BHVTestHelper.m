//
//  BHVTestHelper.m
//  Beehive
//
//  Created by Ryan Davies on 21/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVTestHelper.h"
#import "BHVContext.h"
#import "BHVExample.h"
#import "BHVHook.h"

NSArray * stackOfContexts(NSUInteger count)
{
    NSMutableArray *contexts = [NSMutableArray array];
    for (NSUInteger i = 0; i < count; i ++) {
        contexts[i] = [[BHVContext alloc] init];
        if (i > 0) [contexts[i-1] addNode:contexts[i]];
    }
    return contexts;
}

NSArray * examplesByAddingToContext(BHVContext *context, BOOL markAsExecuted)
{
    NSMutableArray *examples = [NSMutableArray array];
    for (NSUInteger i = 0; i < 10; i ++) {
        examples[i] = [[BHVExample alloc] init];
        [examples[i] setExecuted:markAsExecuted];
        [context addNode:examples[i]];
    }
    return examples;
};

NSArray * hooksByAddingToContext(BHVContext *context)
{
    NSMutableArray *hooks = [NSMutableArray array];
    for (NSUInteger i = 0; i < 10; i ++) {
        hooks[i] = [[BHVHook alloc] init];
        [context addNode:hooks[i]];
    }
    return hooks;
}

@implementation BHVTestSpec1
@end

@implementation BHVTestSpec2
@end

@implementation BHVTestSpec3
@end
