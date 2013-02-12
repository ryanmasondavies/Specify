//
//  SPCDSLSpec.m
//  Specify
//
//  Created by Ryan Davies on 15/01/2013.
//  Copyright (c) 2013 Ryan Davies. All rights reserved.
//

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
