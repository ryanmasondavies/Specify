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

#pragma mark - Invocation

@interface BHVInvocation : NSInvocation
@property (strong, nonatomic) BHVExample *example;
+ (instancetype)invocationWithExample:(BHVExample *)example;
@end

@implementation BHVInvocation

+ (instancetype)invocationWithExample:(BHVExample *)example
{
    NSString *encodingType = [NSString stringWithFormat:@"%s%s%s", @encode(void), @encode(id), @encode(SEL)];
    NSMethodSignature *methodSignature = [NSMethodSignature signatureWithObjCTypes:[encodingType UTF8String]];
    BHVInvocation *invocation = (id)[BHVInvocation invocationWithMethodSignature:methodSignature];
    [invocation setExample:example];
    return invocation;
}

- (void)invoke
{
    [[self example] execute];
}

@end

#pragma mark - Specification

@interface BHVSpecification ()
+ (void)setCurrentSpecification:(Class)specification;
+ (Class)currentSpecification;
+ (NSMutableArray *)contextStack;
+ (NSMutableArray *)contexts;
+ (NSMutableArray *)examples;
+ (NSMutableArray *)hooks;
@end

@implementation BHVSpecification

+ (void)setCurrentSpecification:(Class)specification
{
    [[[NSThread currentThread] threadDictionary] setObject:specification forKey:@"BHVCurrentSpecification"];
}

+ (Class)currentSpecification
{
    return [[[NSThread currentThread] threadDictionary] objectForKey:@"BHVCurrentSpecification"];
}

CLASS_PROPERTY(contextStack, NSMutableArray);
CLASS_PROPERTY(contexts,     NSMutableArray);
CLASS_PROPERTY(examples,     NSMutableArray);
CLASS_PROPERTY(hooks,        NSMutableArray);

+ (void)initialize
{
    BHVSpecification *instance = [[[self class] alloc] init];
    [self setCurrentSpecification:self];
    [instance loadExamples];
    [super initialize];
}

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

- (void)loadExamples
{
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

+ (void)reset
{
    [[self contexts] removeAllObjects];
    [[self examples] removeAllObjects];
    [[self hooks]    removeAllObjects];
    
    [self initialize];
}

@end

#pragma mark - DSL

void it(NSString *name, void(^block)(void))
{
    BHVExample *example = [[BHVExample alloc] initWithName:name block:block];
    [[BHVSpecification currentSpecification] addExample:example];
}

void context(NSString *name, void(^block)(void))
{
    // Create context:
    BHVContext *context = [[BHVContext alloc] initWithName:name];
    
    // Add context and its contents to the specification:
    [[BHVSpecification currentSpecification] enterContext:context];
    block();
    [[BHVSpecification currentSpecification] leaveContext];
}

void describe(NSString *name, void(^block)(void))
{
    context(name, block);
}

void beforeAll(void(^block)(void))
{
    BHVHook *hook = [[BHVHook alloc] initWithFlavor:BHVHookFlavorBeforeAll];
    [hook setBlock:block];
    [[BHVSpecification currentSpecification] addHook:hook];
}

void afterAll(void(^block)(void))
{
    BHVHook *hook = [[BHVHook alloc] initWithFlavor:BHVHookFlavorAfterAll];
    [hook setBlock:block];
    [[BHVSpecification currentSpecification] addHook:hook];
}

void beforeEach(void(^block)(void))
{
    BHVHook *hook = [[BHVHook alloc] initWithFlavor:BHVHookFlavorBeforeEach];
    [hook setBlock:block];
    [[BHVSpecification currentSpecification] addHook:hook];
}

void afterEach(void(^block)(void))
{
    BHVHook *hook = [[BHVHook alloc] initWithFlavor:BHVHookFlavorAfterEach];
    [hook setBlock:block];
    [[BHVSpecification currentSpecification] addHook:hook];
}
