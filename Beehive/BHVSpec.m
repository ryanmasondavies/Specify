//
//  BHVSpec.m
//  Beehive
//
//  Created by Ryan Davies on 11/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVSpec.h"
#import "BHVSuite.h"
#import "BHVSuiteRegistry.h"
#import "BHVExample.h"
#import "BHVInvocation.h"

@implementation BHVSpec

+ (void)defineBehaviour
{
    NSArray *examples = [self examples];
    if (examples == nil) return;
    
    BHVSuite *suite = [[BHVSuite alloc] init];
    [suite setExamples:examples];
    
    [[BHVSuiteRegistry sharedRegistry] registerSuite:suite forClass:[self class]];
}

+ (NSArray *)examples
{
    return nil; // Overridden by subclasses.
}

+ (NSArray *)testInvocations
{
    [self defineBehaviour];
    
    BHVSuite *suite = [[BHVSuiteRegistry sharedRegistry] suiteForClass:[self class]];
    
    NSMutableArray *invocations = [NSMutableArray array];
    [[suite examples] enumerateObjectsUsingBlock:^(BHVExample *example, NSUInteger idx, BOOL *stop) {
        BHVInvocation *invocation = [BHVInvocation emptyInvocation];
        [invocation setExample:example];
        [invocations addObject:invocation];
    }];
    
    return [NSArray arrayWithArray:invocations];
}

- (BHVExample *)currentExample
{
    return [(BHVInvocation *)[self invocation] example];
}

- (NSString *)name
{
    return [[self currentExample] description];
}

@end
