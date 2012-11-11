//
//  BHVSpec.m
//  Beehive
//
//  Created by Ryan Davies on 11/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVSpec.h"
#import "BHVExample.h"
#import "BHVCompiler.h"

void example(NSString *description, BHVVoidBlock block)
{
    BHVExample *example = [[BHVExample alloc] init];
    [example setDescription:description];
    [example setBlock:block];
    [[BHVCompiler sharedCompiler] addExample:example];
}

void it(NSString *description, BHVVoidBlock block)
{
    example(description, block);
}

@interface BHVExampleInvocation : NSInvocation
@property (nonatomic, strong) BHVExample *example;
@end

@implementation BHVExampleInvocation
- (void)invoke { [[self example] execute]; }
@end

@interface BHVSpec ()
- (BHVExample *)currentExample;
@end

@implementation BHVSpec

+ (void)defineBehaviour
{
    // Overridden by subclasses.
}

+ (NSArray *)testInvocations
{
    // Compile examples:
    BHVCompiler *compiler = [BHVCompiler sharedCompiler];
    [compiler compile:^{ [self defineBehaviour]; }];
    
    // Generate invocations:
    NSMutableArray *invocations = [NSMutableArray array];
    [[compiler compiledExamples] enumerateObjectsUsingBlock:^(BHVExample *example, NSUInteger idx, BOOL *stop) {
        NSString *encodingType = [NSString stringWithFormat:@"%s%s%s", @encode(void), @encode(id), @encode(SEL)];
        NSMethodSignature *methodSignature = [NSMethodSignature signatureWithObjCTypes:[encodingType UTF8String]];
        BHVExampleInvocation *invocation = (BHVExampleInvocation *)[BHVExampleInvocation invocationWithMethodSignature:methodSignature];
        [invocation setExample:example];
        [invocations addObject:invocation];
    }];
    
    return invocations;
}

- (BHVExample *)currentExample
{
    return [(BHVExampleInvocation *)[self invocation] example];
}

- (NSString *)name
{
    return [[self currentExample] description];
}

@end
