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

SpecBegin(SPCHooks)

before(^{
    [order addObject:@1];
});

after(^{
    [order addObject:@7];
});

context(@"in a context", ^{
    before(^{
        [order addObject:@2];
    });
    
    after(^{
        [order addObject:@6];
    });
    
    context(@"in another context", ^{
        before(^{
            [order addObject:@3];
        });
        
        after(^{
            [order addObject:@5];
        });
        
        it(@"should run this example", ^{
            [order addObject:@4];
        });
    });
});

SpecEnd

@interface SPCHooksTests : SenTestCase

@end

@implementation SPCHooksTests

- (void)testRunsHooksInOrder
{
    order = [[NSMutableArray alloc] init];
    [SPCSpecRunner runSpecForClass:[SPCHooksSpec class]];
    [[order should] beEqualTo:@[@1, @2, @3, @4, @5, @6, @7]];
}

@end
