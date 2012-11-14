//
//  BHVExpectation.m
//  Beehive
//
//  Created by Ryan Davies on 14/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVExpectation.h"

@implementation BHVExpectation

- (id)initWithSubject:(id)subject
{
    self.subject = subject;
    return self;
}

- (void)verify
{
    if ([[self invocation] selector] == @selector(beEqualTo:)) {
        id object;
        [[self invocation] getArgument:&object atIndex:2];
        
        if ([[self subject] isEqual:object] == NO) {
            [NSException raise:NSInvalidArgumentException format:@"Expectation failed."];
        }
    }
}

- (BOOL)beEqualTo:(id)object
{
    return NO;
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    [self setInvocation:invocation];
}

@end
