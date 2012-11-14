//
//  BHVExpectation.m
//  Beehive
//
//  Created by Ryan Davies on 14/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVExpectation.h"
#import "BHVMatcher.h"
#import "BHVMatcherRegistry.h"

@implementation BHVExpectation

- (id)initWithSubject:(id)subject
{
    self = [super init];
    if (self)
        self.subject = subject;
    
    return self;
}

- (void)verify
{
    BOOL result = NO;
    
    [[self invocation] invokeWithTarget:[self matcher]];
    [[self invocation] getReturnValue:&result];
    
    if (result == NO) [NSException raise:NSInvalidArgumentException format:@"Expectation failed."];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    [self setInvocation:invocation];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    Class klass = [[BHVMatcherRegistry sharedRegistry] classWhoseInstancesRespondToSelector:selector];
    self.matcher = [[klass alloc] initWithSubject:[self subject]];
    return [[self matcher] methodSignatureForSelector:selector];
}

@end
