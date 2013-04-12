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

#import "SPCBuilder.h"
#import "INLGroup.h"
#import "SPCExample.h"

@interface SPCBuilder ()
@property (strong, nonatomic) NSMutableArray *stack;
@end

@implementation SPCBuilder

- (id)init
{
    if (self = [super init]) {
        self.stack = [NSMutableArray arrayWithObject:[self rootGroup]];
    }
    return self;
}

- (void)enterGroup:(INLGroup *)group
{
    [[self stack] addObject:group];
}

- (void)leaveGroup
{
    // Pop a group from the group stack:
    INLGroup *group = [[self stack] lastObject];
    [[self stack] removeLastObject];
    
    // Add the popped group to what is now the top group:
    [[[self stack] lastObject] addNode:group];
}

- (void)addExample:(SPCExample *)example
{
    [[[self stack] lastObject] addNode:example];
}

- (void)addHook:(INLBlockHook *)hook
{
    [[[self stack] lastObject] addNode:hook];
}

@end
