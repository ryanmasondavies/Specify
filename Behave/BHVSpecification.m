//
//  BHVSpecification.m
//  Behave
//
//  Created by Ryan Davies on 30/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVSpecification.h"
#import "BHVContext.h"
#import "BHVExample.h"
#import "BHVHook.h"

@interface BHVSpecification ()
+ (NSMutableArray *)contextStack;
+ (NSMutableArray *)contexts;
+ (NSMutableArray *)examples;
+ (NSMutableArray *)hooks;
@end

@implementation BHVSpecification

+ (void)enterContext:(BHVContext *)context
{
    // Push the context to the context stack:
    [[self contextStack] addObject:context];
}

+ (void)leaveContext
{
    // Pop a context from the context stack:
    BHVContext *context = [[self contextStack] lastObject];
    [[self contextStack] removeLastObject];
    
    // Add the popped context to what is now the top context, if there is one.
    // If not, add it to the array of contexts.
    BHVContext *topContext = [[self contextStack] lastObject];
    if (topContext)
        [topContext addContext:context];
    else
        [[self contexts] addObject:context];
}

+ (void)addExample:(BHVExample *)example
{
    // Raise an exception if adding examples to BHVSpecification base class:
    if (self == [BHVSpecification class])
        [NSException raise:NSInternalInconsistencyException format:@"Cannot add examples to the BHVSpecification base class."];
    
    // Add example to the top context, if there is one.
    // If not, add it to the array of examples.
    BHVContext *context = [[self contextStack] lastObject];
    if (context)
        [context addExample:example];
    else
        [[self examples] addObject:example];
}

+ (void)addHook:(BHVHook *)hook
{
    // Raise an exception if adding examples to BHVSpecification base class:
    if (self == [BHVSpecification class])
        [NSException raise:NSInternalInconsistencyException format:@"Cannot add examples to the BHVSpecification base class."];
    
    // Add example to the top context, if there is one.
    // If not, add it to the array of examples.
    BHVContext *context = [[self contextStack] lastObject];
    if (context)
        [context addHook:hook];
    else
        [[self hooks] addObject:hook];
}

+ (NSMutableArray *)contextStack
{
    // Return a stack of contexts for this class:
    static NSMutableDictionary *contextStackByClass = nil;
    if (contextStackByClass == nil) contextStackByClass = [NSMutableDictionary dictionary];
    NSMutableArray *contextStack = [contextStackByClass objectForKey:NSStringFromClass(self)];
    if (contextStack == nil) {
        contextStack = [NSMutableArray array];
        [contextStackByClass setObject:contextStack forKey:NSStringFromClass(self)];
    }
    return contextStack;
}

+ (NSMutableArray *)contexts
{
    // Return an array of contexts for this class:
    static NSMutableDictionary *contextsByClass = nil;
    if (contextsByClass == nil) contextsByClass = [NSMutableDictionary dictionary];
    NSMutableArray *contexts = [contextsByClass objectForKey:NSStringFromClass(self)];
    if (contexts == nil) {
        contexts = [NSMutableArray array];
        [contextsByClass setObject:contexts forKey:NSStringFromClass(self)];
    }
    return contexts;
}

+ (NSMutableArray *)examples
{
    // Return an array of examples for this class:
    static NSMutableDictionary *examplesByClass = nil;
    if (examplesByClass == nil) examplesByClass = [NSMutableDictionary dictionary];
    NSMutableArray *examples = [examplesByClass objectForKey:NSStringFromClass(self)];
    if (examples == nil) {
        examples = [NSMutableArray array];
        [examplesByClass setObject:examples forKey:NSStringFromClass(self)];
    }
    return examples;
}

+ (NSMutableArray *)hooks
{
    // Return an array of hooks for this class:
    static NSMutableDictionary *hooksByClass = nil;
    if (hooksByClass == nil) hooksByClass = [NSMutableDictionary dictionary];
    NSMutableArray *hooks = [hooksByClass objectForKey:NSStringFromClass(self)];
    if (hooks == nil) {
        hooks = [NSMutableArray array];
        [hooksByClass setObject:hooks forKey:NSStringFromClass(self)];
    }
    return hooks;
}

@end
