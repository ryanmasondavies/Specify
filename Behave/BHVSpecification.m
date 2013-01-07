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

#pragma mark Invocation

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
@end

@implementation BHVSpecification

+ (void)initialize
{
    // Add base context:
    [[self contextStack] addObject:[BHVContext new]];
    
    // Load examples:
    BHVSpecification *instance = [[[self class] alloc] init];
    [self setCurrentSpecification:self];
    [instance loadExamples];
    
    // Allow SenTestCase to initialize:
    [super initialize];
}

+ (void)setCurrentSpecification:(Class)specification
{
    [[[NSThread currentThread] threadDictionary] setObject:specification forKey:@"BHVCurrentSpecification"];
}

+ (Class)currentSpecification
{
    return [[[NSThread currentThread] threadDictionary] objectForKey:@"BHVCurrentSpecification"];
}

+ (NSMutableArray *)contextStack
{
    static NSMutableDictionary *contextStackByClass = nil;
    if (contextStackByClass == nil) contextStackByClass = [NSMutableDictionary dictionary];
    NSMutableArray *contextStack = [contextStackByClass objectForKey:NSStringFromClass(self)];
    if (contextStack == nil) {
        contextStack = [NSMutableArray array];
        [contextStackByClass setObject:contextStack forKey:NSStringFromClass(self)];
    }
    return contextStack;
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
    
    // Add the popped context to what is now the top context:
    [[[self contextStack] lastObject] addContext:context];
}

+ (void)addExample:(BHVExample *)example
{
    // Raise an exception if adding to the base specification:
    if (self == [BHVSpecification class]) [NSException raise:NSInternalInconsistencyException format:@"Cannot add examples to the base specification."];
    
    // Add example to the top context:
    [[[self contextStack] lastObject] addExample:example];
}

+ (void)addHook:(BHVHook *)hook
{
    // Raise an exception if adding to the base specification:
    if (self == [BHVSpecification class]) [NSException raise:NSInternalInconsistencyException format:@"Cannot add hooks to the base specification."];
    
    // Add example to the top context:
    [[[self contextStack] lastObject] addHook:hook];
}

+ (NSArray *)testInvocations
{
    // Gather examples:
    NSMutableArray *examples = [NSMutableArray array];
    
    // Start at the top-most context:
    BHVContext *topMostContext = [[self contextStack] objectAtIndex:0];
    NSMutableArray *contextQueue = [NSMutableArray arrayWithObject:topMostContext];
    
    // Pop off the first context:
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
        if ([context name])
            [names insertObject:[context name] atIndex:0];
        context = [context parentContext];
    }
    [names addObject:[example name]];
    return [names componentsJoinedByString:@" "];
}

+ (void)reset
{
    [[self contextStack] removeAllObjects];
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
    BHVHook *hook = [[BHVHook alloc] initWithScope:BHVHookScopeBeforeAll];
    [hook setBlock:block];
    [[BHVSpecification currentSpecification] addHook:hook];
}

void afterAll(void(^block)(void))
{
    BHVHook *hook = [[BHVHook alloc] initWithScope:BHVHookScopeAfterAll];
    [hook setBlock:block];
    [[BHVSpecification currentSpecification] addHook:hook];
}

void beforeEach(void(^block)(void))
{
    BHVHook *hook = [[BHVHook alloc] initWithScope:BHVHookScopeBeforeEach];
    [hook setBlock:block];
    [[BHVSpecification currentSpecification] addHook:hook];
}

void afterEach(void(^block)(void))
{
    BHVHook *hook = [[BHVHook alloc] initWithScope:BHVHookScopeAfterEach];
    [hook setBlock:block];
    [[BHVSpecification currentSpecification] addHook:hook];
}
