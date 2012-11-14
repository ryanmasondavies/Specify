//
//  BHVExpectation.m
//  Beehive
//
//  Created by Ryan Davies on 14/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVExpectation.h"

@implementation BHVEqualityMatcher

- (id)initWithSubject:(id)subject
{
    self = [super init];
    if (self) {
        self.subject = subject;
    }
    return self;
}

- (BOOL)beEqualTo:(id)object
{
    return [[self subject] isEqual:object];
}

@end

@interface BHVExpectation ()
@property (nonatomic, strong) BHVEqualityMatcher *matcher;
@end

@implementation BHVExpectation

- (id)initWithSubject:(id)subject
{
    self.subject = subject;
    return self;
}

- (void)verify
{
    BOOL result = NO;
    
    [[self invocation] invokeWithTarget:[self matcher]];
    [[self invocation] getArgument:&result atIndex:2];
    
    if (result == NO) [NSException raise:NSInvalidArgumentException format:@"Expectation failed."];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    [self setInvocation:invocation];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    if ([BHVEqualityMatcher instancesRespondToSelector:selector])
        self.matcher = [[BHVEqualityMatcher alloc] initWithSubject:[self subject]];
    
    return [[self matcher] methodSignatureForSelector:selector];
}

@end
