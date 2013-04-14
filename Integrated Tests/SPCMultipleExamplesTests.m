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

SpecBegin(SPCMultipleExamples)

void(^it)(NSString *, INLVoidBlock) = ^(NSString *name, INLVoidBlock block) {
    INLTest *test = [[INLTest alloc] initWithName:name block:block delegate:nil];
    [tests addObject:test];
};

it(@"should run this example first", ^{
    [order addObject:@1];
});

it(@"should run this example second", ^{
    [order addObject:@2];
});

SpecEnd

@interface SPCMultipleExamplesTests : SenTestCase

@end

@implementation SPCMultipleExamplesTests

- (void)testRunsExamplesInOrder
{
    order = [[NSMutableArray alloc] init];
    [SPCSpecRunner runSpecForClass:[SPCMultipleExamplesSpec class]];
    [[order should] beEqualTo:@[@1, @2]];
}

@end
