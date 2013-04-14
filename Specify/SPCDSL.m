// The MIT License
// 
// Copyright (c) 2013 Ryan Davies
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "SPCDSL.h"

@interface SPCDSL ()
@property (strong, nonatomic) NSMutableArray *tests;
@property (strong, nonatomic) NSMutableArray *nameStack;
@property (strong, nonatomic) NSMutableArray *contextStack;
@property (strong, nonatomic) NSMutableArray *contextDelegatesStack;
@end

@implementation SPCDSL

- (id)initWithTests:(NSMutableArray *)tests nameStack:(NSMutableArray *)nameStack contextStack:(NSMutableArray *)contextStack contextDelegatesStack:(NSMutableArray *)contextDelegatesStack
{
    if (self = [self init]) {
        [self setTests:tests];
        [self setNameStack:nameStack];
        [self setContextStack:contextStack];
        [self setContextDelegatesStack:contextDelegatesStack];
    }
    return self;
}

- (void (^)(NSString *, INLVoidBlock))context
{
    return ^(NSString *name, INLVoidBlock block) {
        NSMutableArray *contextDelegates = [[NSMutableArray alloc] init];
        INLContext *context = [[INLContext alloc] initWithDelegates:contextDelegates];
        
        [[self nameStack] addObject:name];
        [[self contextStack] addObject:context];
        [[self contextDelegatesStack] addObject:contextDelegates];
        
        block();
        
        [[self nameStack] removeLastObject];
        [[self contextStack] removeLastObject];
        [[self contextDelegatesStack] removeLastObject];
    };
}

- (void (^)(NSString *, INLVoidBlock))it
{
    return ^(NSString *name, INLVoidBlock block) {
        [[self nameStack] addObject:name];
        name = [[self nameStack] componentsJoinedByString:@" "];
        INLContext *context = [[INLContext alloc] initWithDelegates:[[self contextStack] copy]];
        INLTest *test = [[INLTest alloc] initWithName:name block:block delegate:context];
        [[self tests] addObject:test];
        [[self nameStack] removeLastObject];
    };
}

- (void(^)(INLVoidBlock))before
{
    return ^(INLVoidBlock block) {
        id<INLRunnable> hook = [[INLHook alloc] initWithBlock:block];
        id<INLTestDelegate> filter = [[INLBeforeFilter alloc] initWithRunnable:hook];
        NSMutableArray *delegates = [[self contextDelegatesStack] lastObject];
        [delegates addObject:filter];
    };
}

- (void(^)(INLVoidBlock))after
{
    return ^(INLVoidBlock block) {
        id<INLRunnable> hook = [[INLHook alloc] initWithBlock:block];
        id<INLTestDelegate> filter = [[INLAfterFilter alloc] initWithRunnable:hook];
        NSMutableArray *delegates = [[self contextDelegatesStack] lastObject];
        [delegates addObject:filter];
    };
}

@end

