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

SpecBegin(SPCDSL)

__block SPCBuilder *builder;
before(^{
    builder = [[SPCBuilder alloc] init];
    [[SPCSpecification currentSpecification] setBuilder:builder];
});

describe(@"it()", ^{
    it(@"creates and adds examples", ^{
        void(^block)(void) = ^{};
        
        it(@"should work", block);
        
        INLBuilder *builder = [[SPCSpecification currentSpecification] builder];
        SPCExample *example = [[builder rootGroup] tests][0];
        
        STAssertNotNil([example label], @"");
        STAssertNotNil([example block], @"");
        
        [[[example label] should] beEqualTo:@"should work"];
        [[[example block] should] beIdenticalTo:block];
    });
});

describe(@"context()", ^{
    it(@"creates and adds a group containing the examples defined within the block", ^{
        void(^block)(void) = ^{
            it(@"should work within contexts", ^{});
        };
        
        context(@"should work", block);
        
        INLGroup   *group   = [[builder rootGroup] groups][0];
        SPCExample *example = [group tests][0];
        
        STAssertNotNil([group label], @"");
        STAssertNotNil([example label], @"");
        STAssertNotNil([example block], @"");
        
        [[[group   label] should] beEqualTo:@"should work"];
        [[[example label] should] beEqualTo:@"should work within contexts"];
        [[[example block] should] beIdenticalTo:block];
    });
});

describe(@"describe()", ^{
    it(@"creates and adds a group containing the examples defined within the block", ^{
        void(^block)(void) = ^{
            it(@"should work within contexts", ^{});
        };
        
        describe(@"should work", block);
        
        INLGroup   *group   = [[builder rootGroup] groups][0];
        SPCExample *example = [group tests][0];
        
        STAssertNotNil([group label], @"");
        STAssertNotNil([example label], @"");
        STAssertNotNil([example block], @"");
        
        [[[group   label] should] beEqualTo:@"should work"];
        [[[example label] should] beEqualTo:@"should work within contexts"];
        [[[example block] should] beIdenticalTo:block];
    });
});

describe(@"when()", ^{
    it(@"creates and adds a group containing the examples defined within the block", ^{
        void(^block)(void) = ^{
            it(@"should work within contexts", ^{});
        };
        
        when(@"should work", block);
        
        INLGroup   *group   = [[builder rootGroup] groups][0];
        SPCExample *example = [group tests][0];
        
        STAssertNotNil([group label], @"");
        STAssertNotNil([example label], @"");
        STAssertNotNil([example block], @"");
        
        [[[group   label] should] beEqualTo:@"when should work"];
        [[[example label] should] beEqualTo:@"should work within contexts"];
        [[[example block] should] beIdenticalTo:block];
    });
});

describe(@"beforeEach()", ^{
    it(@"creates a hook with placement of 'before'", ^{
        void (^block)(void) = ^{};
        beforeEach(block);
        
        INLBlockHook *hook = [[builder rootGroup] hooks][0];
        STAssertNotNil([hook block], @"");
        [[@([hook placement]) should] beEqualTo:@(INLHookPlacementBefore)];
        [[[hook block] should] beIdenticalTo:block];
    });
});

describe(@"before()", ^{
    it(@"creates a hook with placement of 'before'", ^{
        void (^block)(void) = ^{};
        before(block);
        
        INLBlockHook *hook = [[builder rootGroup] hooks][0];
        STAssertNotNil([hook block], @"");
        [[@([hook placement]) should] beEqualTo:@(INLHookPlacementBefore)];
        [[[hook block] should] beIdenticalTo:block];
    });
});

describe(@"afterEach()", ^{
    it(@"creates a hook with placement of 'after'", ^{
        void (^block)(void) = ^{};
        afterEach(block);
        
        INLBlockHook *hook = [[builder rootGroup] hooks][0];
        STAssertNotNil([hook block], @"");
        [[@([hook placement]) should] beEqualTo:@(INLHookPlacementAfter)];
        [[[hook block] should] beIdenticalTo:block];
    });
});

describe(@"after()", ^{
    it(@"creates a hook with placement of 'after'", ^{
        void (^block)(void) = ^{};
        after(block);
        
        INLBlockHook *hook = [[builder rootGroup] hooks][0];
        STAssertNotNil([hook block], @"");
        [[@([hook placement]) should] beEqualTo:@(INLHookPlacementAfter)];
        [[[hook block] should] beIdenticalTo:block];
    });
});

SpecEnd
