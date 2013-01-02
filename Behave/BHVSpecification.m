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

#define CLASS_PROPERTY(name, type) \
+ (type *)name \
{ \
static NSMutableDictionary *name##ByClass = nil; \
if (name##ByClass == nil) name##ByClass = [NSMutableDictionary dictionary]; \
NSMutableArray *name = [name##ByClass objectForKey:NSStringFromClass(self)]; \
if (name == nil) { \
name = [NSMutableArray array]; \
[name##ByClass setObject:name forKey:NSStringFromClass(self)]; \
} \
return name; \
}

@implementation BHVInvocation

+ (instancetype)invocationWithExample:(BHVExample *)example
{
    NSString *encodingType = [NSString stringWithFormat:@"%s%s%s", @encode(void), @encode(id), @encode(SEL)];
    NSMethodSignature *methodSignature = [NSMethodSignature signatureWithObjCTypes:[encodingType UTF8String]];
    BHVInvocation *invocation = (id)[BHVInvocation invocationWithMethodSignature:methodSignature];
    [invocation setExample:example];
    return invocation;
}

@end

@interface BHVSpecification ()
+ (NSMutableArray *)contextStack;
+ (NSMutableArray *)contexts;
+ (NSMutableArray *)examples;
+ (NSMutableArray *)hooks;
@end

@implementation BHVSpecification

CLASS_PROPERTY(contextStack, NSMutableArray);
CLASS_PROPERTY(contexts,     NSMutableArray);
CLASS_PROPERTY(examples,     NSMutableArray);
CLASS_PROPERTY(hooks,        NSMutableArray);

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

+ (NSArray *)testInvocations
{
    // Gather examples:
    NSMutableArray *examples = [NSMutableArray arrayWithArray:[self examples]];
    
    // If there are contexts...
    NSMutableArray *contextQueue = [NSMutableArray arrayWithArray:[self contexts]];
    if ([contextQueue count] > 0) {
        // Start with the first context:
        BHVContext *currentContext = [contextQueue objectAtIndex:0];
        [contextQueue removeObjectAtIndex:0];
        
        // Until currentContext is nil:
        while (currentContext) {
            // Add context's examples to list:
            [examples addObjectsFromArray:[currentContext examples]];
            
            // Add nested contexts to queue:
            [contextQueue addObjectsFromArray:[currentContext contexts]];
            
            // Move on to the next context, if there is one:
            if ([contextQueue count] > 0) {
                currentContext = [contextQueue objectAtIndex:0];
                [contextQueue removeObjectAtIndex:0];
            } else {
                currentContext = nil;
            }
        }
    }
    
    // Create invocations from examples:
    NSMutableArray *invocations = [NSMutableArray array];
    [examples enumerateObjectsUsingBlock:^(BHVExample *example, NSUInteger idx, BOOL *stop) {
        [invocations addObject:[BHVInvocation invocationWithExample:example]];
    }];
    
    // Convert to immutable and return:
    return [NSArray arrayWithArray:invocations];
}

- (NSString *)name
{
    NSMutableArray *names = [NSMutableArray array];
    BHVExample *example = [(BHVInvocation *)[self invocation] example];
    BHVContext *context = [example parentContext];
    while (context != nil) {
        [names insertObject:[context name] atIndex:0];
        context = [context parentContext];
    }
    [names addObject:[example name]];
    return [names componentsJoinedByString:@" "];
}

@end
