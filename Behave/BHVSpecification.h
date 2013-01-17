//
//  BHVSpecification.h
//  Behave
//
//  Created by Ryan Davies on 30/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
@class BHVBuilder;

/**
 Provides an abstract superclass for each specification in a spec suite.
 
 Each specification is a class, not an instance. Instances of this class are test cases, due to the way in which SenTestingKit works, and so are used for executing individual examples.
 
 For each subclass initialized, an instance is created and loadExamples is called.
 
 @note Examples are not added directly. This responsibility is handled by BHVBuilder, an instance of which is available for each subclass through the builder method. Invocations for each example added to the builder are generated by the SenTestCase method testInvocations.
 */
@interface BHVSpecification : SenTestCase

/**
 @param specification The current specification class being loaded, for later retrieval using currentSpecification.
 */
+ (void)setCurrentSpecification:(Class)specification;

/**
 @return The class for the specification currently being loaded.
 */
+ (Class)currentSpecification;

/**
 @return An instance of BHVBuilder, one for each subclass of BHVSpecification.
 */
+ (BHVBuilder *)builder;

/**
 @return An instance of BHVInvocation for each example in the builder.
 */
+ (NSArray *)testInvocations;

/**
 Used by subclasses for providing examples to the current specification's builder.
 
 Implementation should refer to the DSL functions.
 */
- (void)loadExamples;

/**
 Resets the state of the specification by recreating the builder, essentially removing all examples. Used primarily for testing.
 
 @warning By abstracting the logic of creating invocations to another class, this method could be removed and tests could be improved.
 */
+ (void)reset;

@end