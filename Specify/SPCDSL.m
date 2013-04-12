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
#import "SPCSpecification.h"
#import "SPCBuilder.h"
#import "SPCExample.h"

void it(NSString *label, void(^block)(void))
{
    SPCExample *example = [[SPCExample alloc] init];
    [example setLabel:label];
    [example setBlock:block];
    [(SPCBuilder *)[[SPCSpecification currentSpecification] builder] addExample:example];
}

void context(NSString *label, void(^block)(void))
{
    // Create group:
    INLGroup *group = [[INLGroup alloc] init];
    [group setLabel:label];
    
    // Add group and its contents to the specification:
    [(SPCBuilder *)[[SPCSpecification currentSpecification] builder] enterGroup:group];
    block();
    [(SPCBuilder *)[[SPCSpecification currentSpecification] builder] leaveGroup];
}

void describe(NSString *label, void(^block)(void))
{
    context(label, block);
}

void when(NSString *label, void(^block)(void))
{
    context([NSString stringWithFormat:@"when %@", label], block);
}

void before(void(^block)(void))
{
    beforeEach(block);
}

void beforeEach(void(^block)(void))
{
    INLBlockHook *hook = [[INLBlockHook alloc] init];
    [hook setPlacement:INLHookPlacementBefore];
    [hook setBlock:block];
    [(SPCBuilder *)[[SPCSpecification currentSpecification] builder] addHook:hook];
}

void after(void(^block)(void))
{
    afterEach(block);
}

void afterEach(void(^block)(void))
{
    INLBlockHook *hook = [[INLBlockHook alloc] init];
    [hook setPlacement:INLHookPlacementAfter];
    [hook setBlock:block];
    [(SPCBuilder *)[[SPCSpecification currentSpecification] builder] addHook:hook];
}
