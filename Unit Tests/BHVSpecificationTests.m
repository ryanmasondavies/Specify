//
//  BHVSpecificationTests.m
//  Behave
//
//  Created by Ryan Davies on 30/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "BHVSpecification.h"
#import "BHVContext.h"
#import "BHVExample.h"
#import "BHVHook.h"

@interface BHVSpecificationA : BHVSpecification
@end
@implementation BHVSpecificationA
@end

@interface BHVSpecificationB : BHVSpecification
@end
@implementation BHVSpecificationB
@end

@interface BHVSpecification ()
+ (NSMutableArray *)contexts;
+ (NSMutableArray *)examples;
+ (NSMutableArray *)hooks;
@end

@interface BHVSpecificationTests : SenTestCase
@end

@implementation BHVSpecificationTests

- (void)tearDown
{
    // Clear all from Specification A:
    [[BHVSpecificationA contexts] removeAllObjects];
    [[BHVSpecificationA examples] removeAllObjects];
    [[BHVSpecificationA hooks] removeAllObjects];
    
    // Clear all from Specification B:
    [[BHVSpecificationB contexts] removeAllObjects];
    [[BHVSpecificationB examples] removeAllObjects];
    [[BHVSpecificationB hooks] removeAllObjects];
}

#pragma mark Adding examples

- (void)testAddingExamples
{
    BHVExample *example = [[BHVExample alloc] init];
    [BHVSpecificationA addExample:example];
    STAssertTrue([[BHVSpecificationA examples] containsObject:example], @"Should have added example to subclass.");
}

- (void)testAddingExamplesToContexts
{
    NSArray *contexts = @[[BHVContext new], [BHVContext new]];
    NSArray *examples = @[[BHVExample new], [BHVExample new]];
    
    [BHVSpecificationA enterContext:contexts[0]];
    [BHVSpecificationA addExample:examples[0]];
    [BHVSpecificationA leaveContext];
    
    [BHVSpecificationA enterContext:contexts[1]];
    [BHVSpecificationA addExample:examples[1]];
    [BHVSpecificationA leaveContext];
    
    STAssertTrue([[BHVSpecificationA contexts] containsObject:contexts[0]], @"Should have added contexts[0] to subclass.");
    STAssertTrue([[contexts[0] examples] containsObject:examples[0]], @"Should have added examples[0] to contexts[0].");
    
    STAssertTrue([[BHVSpecificationA contexts] containsObject:contexts[1]], @"Should have added contexts[1] to subclass.");
    STAssertTrue([[contexts[1] examples] containsObject:examples[1]], @"Should have added examples[1] to contexts[1].");
}

- (void)testAddingExamplesToNestedContexts
{
    NSArray *contexts = @[[BHVContext new], [BHVContext new], [BHVContext new]];
    NSArray *examples = @[[BHVExample new], [BHVExample new], [BHVExample new]];
    
    [BHVSpecificationA enterContext:contexts[0]];
    [BHVSpecificationA addExample:examples[0]];
    
    [BHVSpecificationA enterContext:contexts[1]];
    [BHVSpecificationA addExample:examples[1]];
    
    [BHVSpecificationA enterContext:contexts[2]];
    [BHVSpecificationA addExample:examples[2]];
    
    [BHVSpecificationA leaveContext];
    [BHVSpecificationA leaveContext];
    [BHVSpecificationA leaveContext];
    
    STAssertTrue([[BHVSpecificationA contexts] containsObject:contexts[0]], @"Should have added contexts[0] to subclass.");
    STAssertTrue([[contexts[0] contexts] containsObject:contexts[1]], @"Should have added contexts[1] to contexts[0].");
    STAssertTrue([[contexts[1] contexts] containsObject:contexts[2]], @"Should have added contexts[2] to contexts[1].");
    
    STAssertTrue([[contexts[0] examples] containsObject:examples[0]], @"Should have added examples[0] to contexts[0].");
    STAssertTrue([[contexts[1] examples] containsObject:examples[1]], @"Should have added examples[1] to contexts[1].");
    STAssertTrue([[contexts[2] examples] containsObject:examples[2]], @"Should have added examples[2] to contexts[2].");
}

- (void)testExamplesCannotBeAddedToBaseClass
{
    STAssertThrows([BHVSpecification addExample:[BHVExample new]], @"Should not be able to add examples to the base class.");
}

- (void)testExamplesAreOnlyAddedToSubclass
{
    BHVExample *example = [BHVExample new];
    [BHVSpecificationA addExample:example];
    STAssertFalse([[BHVSpecificationB examples] containsObject:example], @"Should not have added example to other subclasses.");
}

#pragma mark Adding hooks

- (void)testAddingHooks
{
    BHVHook *hook = [[BHVHook alloc] init];
    [BHVSpecificationA addHook:hook];
    STAssertTrue([[BHVSpecificationA hooks] containsObject:hook], @"Should have added hook to subclass.");
}

- (void)testAddingHooksToContexts
{
    NSArray *contexts = @[[BHVContext new], [BHVContext new]];
    NSArray *hooks = @[[BHVHook new], [BHVHook new]];
    
    [BHVSpecificationA enterContext:contexts[0]];
    [BHVSpecificationA addHook:hooks[0]];
    [BHVSpecificationA leaveContext];
    
    [BHVSpecificationA enterContext:contexts[1]];
    [BHVSpecificationA addHook:hooks[1]];
    [BHVSpecificationA leaveContext];
    
    STAssertTrue([[BHVSpecificationA contexts] containsObject:contexts[0]], @"Should have added contexts[0] to subclass.");
    STAssertTrue([[contexts[0] hooks] containsObject:hooks[0]], @"Should have added hooks[0] to contexts[0].");
    
    STAssertTrue([[BHVSpecificationA contexts] containsObject:contexts[1]], @"Should have added contexts[1] to subclass.");
    STAssertTrue([[contexts[1] hooks] containsObject:hooks[1]], @"Should have added hooks[1] to contexts[1].");
}

- (void)testAddingHooksToNestedContexts
{
    NSArray *contexts = @[[BHVContext new], [BHVContext new], [BHVContext new]];
    NSArray *hooks = @[[BHVHook new], [BHVHook new], [BHVHook new]];
    
    [BHVSpecificationA enterContext:contexts[0]];
    [BHVSpecificationA addHook:hooks[0]];
    
    [BHVSpecificationA enterContext:contexts[1]];
    [BHVSpecificationA addHook:hooks[1]];
    
    [BHVSpecificationA enterContext:contexts[2]];
    [BHVSpecificationA addHook:hooks[2]];
    
    [BHVSpecificationA leaveContext];
    [BHVSpecificationA leaveContext];
    [BHVSpecificationA leaveContext];
    
    STAssertTrue([[BHVSpecificationA contexts] containsObject:contexts[0]], @"Should have added contexts[0] to subclass.");
    STAssertTrue([[contexts[0] contexts] containsObject:contexts[1]], @"Should have added contexts[1] to contexts[0].");
    STAssertTrue([[contexts[1] contexts] containsObject:contexts[2]], @"Should have added contexts[2] to contexts[1].");
    
    STAssertTrue([[contexts[0] hooks] containsObject:hooks[0]], @"Should have added hooks[0] to contexts[0].");
    STAssertTrue([[contexts[1] hooks] containsObject:hooks[1]], @"Should have added hooks[1] to contexts[1].");
    STAssertTrue([[contexts[2] hooks] containsObject:hooks[2]], @"Should have added hooks[2] to contexts[2].");
}

- (void)testHooksCannotBeAddedToBaseClass
{
    STAssertThrows([BHVSpecification addHook:[BHVHook new]], @"Should not be able to add hooks to the base class.");
}

- (void)testHooksAreOnlyAddedToSubclass
{
    BHVHook *hook = [BHVHook new];
    [BHVSpecificationA addHook:hook];
    STAssertFalse([[BHVSpecificationB hooks] containsObject:hook], @"Should not have added hook to other subclasses.");
}

#pragma mark Generating invocations

- (void)testExamplesInContextsAreMovedToEnd
{
}

@end
