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

static NSMutableArray *order;

SpecBegin(SPCNestedExamples)

it(@"should run this example first as it's at the top level", ^{
    [order addObject:@1];
});

context(@"within the context", ^{
    it(@"should run this example next", ^{
        [order addObject:@2];
    });
    
    it(@"should run this example third", ^{
        [order addObject:@3];
    });
});

describe(@"another context", ^{
    it(@"should run this example fourth", ^{
        [order addObject:@4];
    });
    
    it(@"should run this example fifth", ^{
        [order addObject:@5];
    });
});

when(@"in yet another context", ^{
    it(@"should run this example last", ^{
        [order addObject:@6];
    });
});

SpecEnd

@interface SPCNestedExamplesTests : SenTestCase

@end

@implementation SPCNestedExamplesTests

- (void)testRunsExamplesInOrder
{
    order = [[NSMutableArray alloc] init];
    [SPCSpecRunner runSpecForClass:[SPCNestedExamplesSpec class]];
    [[order should] beEqualTo:@[@1, @2, @3, @4, @5, @6]];
}

@end
