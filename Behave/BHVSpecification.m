//
//  BHVSpecification.m
//  Behave
//
//  Created by Ryan Davies on 30/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVSpecification.h"
#import "BHVGroup.h"
#import "BHVExample.h"
#import "BHVBeforeEachHook.h"
#import "BHVAfterEachHook.h"

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
+ (NSMutableArray *)groupStack;
@end

@implementation BHVSpecification

+ (void)initialize
{
    // Add base group:
    [[self groupStack] addObject:[BHVGroup new]];
    
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

+ (NSMutableArray *)groupStack
{
    static NSMutableDictionary *groupStackByClass = nil;
    if (groupStackByClass == nil) groupStackByClass = [NSMutableDictionary dictionary];
    NSMutableArray *groupStack = [groupStackByClass objectForKey:NSStringFromClass(self)];
    if (groupStack == nil) {
        groupStack = [NSMutableArray array];
        [groupStackByClass setObject:groupStack forKey:NSStringFromClass(self)];
    }
    return groupStack;
}

+ (void)enterGroup:(BHVGroup *)group
{
    // Push the group to the group stack:
    [[self groupStack] addObject:group];
}

+ (void)leaveGroup
{
    // Pop a group from the group stack:
    BHVGroup *group = [[self groupStack] lastObject];
    [[self groupStack] removeLastObject];
    
    // Add the popped group to what is now the top group:
    [[[self groupStack] lastObject] addGroup:group];
}

+ (void)addExample:(BHVExample *)example
{
    // Raise an exception if adding to the base specification:
    if (self == [BHVSpecification class]) [NSException raise:NSInternalInconsistencyException format:@"Cannot add examples to the base specification."];
    
    // Add example to the top group:
    [[[self groupStack] lastObject] addExample:example];
}

+ (void)addHook:(BHVHook *)hook
{
    // Raise an exception if adding to the base specification:
    if (self == [BHVSpecification class]) [NSException raise:NSInternalInconsistencyException format:@"Cannot add hooks to the base specification."];
    
    // Add example to the top group:
    [[[self groupStack] lastObject] addHook:hook];
}

+ (NSArray *)testInvocations
{
    // Gather examples:
    NSMutableArray *examples = [NSMutableArray array];
    
    // Start at the top-most group:
    BHVGroup *topMostGroup = [[self groupStack] objectAtIndex:0];
    NSMutableArray *groupQueue = [NSMutableArray arrayWithObject:topMostGroup];
    
    // Pop off the first group:
    BHVGroup *currentGroup = [groupQueue objectAtIndex:0];
    [groupQueue removeObjectAtIndex:0];
    
    // Until currentGroup is nil:
    while (currentGroup) {
        // Add group's examples to list:
        [examples addObjectsFromArray:[currentGroup examples]];
        
        // Add nested groups to queue:
        [groupQueue addObjectsFromArray:[currentGroup groups]];
        
        // Move on to the next group, if there is one:
        if ([groupQueue count] > 0) {
            currentGroup = [groupQueue objectAtIndex:0];
            [groupQueue removeObjectAtIndex:0];
        } else {
            currentGroup = nil;
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
    BHVGroup *group = [example parentGroup];
    while (group != nil) {
        if ([group name])
            [names insertObject:[group name] atIndex:0];
        group = [group parentGroup];
    }
    [names addObject:[example name]];
    return [names componentsJoinedByString:@" "];
}

+ (void)reset
{
    [[self groupStack] removeAllObjects];
    [self initialize];
}

@end

#pragma mark - DSL

void it(NSString *name, void(^block)(void))
{
    BHVExample *example = [[BHVExample alloc] initWithName:name block:block];
    [[BHVSpecification currentSpecification] addExample:example];
}

void group(NSString *name, void(^block)(void))
{
    // Create group:
    BHVGroup *group = [[BHVGroup alloc] initWithName:name];
    
    // Add group and its contents to the specification:
    [[BHVSpecification currentSpecification] enterGroup:group];
    block();
    [[BHVSpecification currentSpecification] leaveGroup];
}

void describe(NSString *name, void(^block)(void))
{
    group(name, block);
}

void beforeEach(void(^block)(void))
{
    BHVHook *hook = [[BHVBeforeEachHook alloc] init];
    [hook setBlock:block];
    [[BHVSpecification currentSpecification] addHook:hook];
}

void afterEach(void(^block)(void))
{
    BHVHook *hook = [[BHVAfterEachHook alloc] init];
    [hook setBlock:block];
    [[BHVSpecification currentSpecification] addHook:hook];
}
