Beehive
=======

Taking inspiration from [Kiwi](), [Cedar](), [Specta]() and [Expecta](), Beehive provides an Rspec-like language with which to write specifications with the intention of being used during [Behaviour Driven Development]().

[Kiwi]: https://github.com/allending/Kiwi
[Cedar]: https://github.com/pivotal/cedar
[Specta]: https://github.com/petejkim/specta
[Expecta]: https://github.com/petejkim/expecta
[Behaviour Driven Development]: http://dannorth.net/introducing-bdd/

Beehive is built on top of OCUnit, allowing tests to be run from Xcode.

All arguments and return types must be provided as objects. This has been made significantly easier by the introduction of literals for the most common data types.

This library is a work in progress, and so the API may be subject to simplification and potentially drastic change. A big thanks to @allending and contributors, as much of the implementation is extracted from Kiwi.

Expectations
============

Matchers
--------

Beehive provides matchers in the format of [[subject should] ...], allowing for more readable examples. The default matchers provided by Beehive are as follows:

    // Existence:
    [object shouldBeNil];
    
    // Equality:
    [[@(1+2) should] be:@3]; // Equivalent to beEqualTo:
    [[@(1+2) should] beEqualTo:@3];
    [[object should] beIdenticalTo:anotherObject];
    
    // Booleans:
    [[@true should] beTrue];
    [[@false should] beFalse];
    [[@YES should] beYes];
    [[@NO should] beNo];
    
    // Numbers:
    [[@0 should] beZero];
    [[@1 should] bePositive];
    [[@(-1) should] beNegative];
    [[@6 should] beGreaterThan:@5];
    [[@5 should] beLessThan:@6];
    [[@6 should] beGreaterThanOrEqualTo:@5];
    [[@5 should] beLessThanOrEqualTo:@6];
    [[@5 should] beBetween:@1 and:@10];
    
    // Objects:
    [[object should] beKindOfClass:[NSObject class]];
    [[object should] beMemberOfClass:[NSObject class]];
    [[object should] conformToProtocol:@protocol(NSCoding)];
    [[object should] respondToSelector:@selector(description)];
    
    // Collections:
    [[pets should] beEmpty];
    [[pets should] contain:cat];
    [[pets should] contain:@[cat, dog]];
    
    // Collections by associations:
    [[[person should] have:2] pets];
    [[[person should] haveAtLeast:2] pets];
    [[[person should] haveAtMost:2] pets];

In order to negate a matcher, either of the following is valid:

    [[@(1+1) shouldNot] beEqualTo:@3];
    [[[@(1+1) should] not] beEqualTo:@3];
    
Use whichever you prefer.

Some of the matchers listed above work based on the dynamic behaviour of Beehive - if no matcher exists with the provided selector, Beehive will attempt to realize the behaviour that you intended, based on convention. If the matcher provided begins with 'be', Beehive will swap 'be' out for 'is' and attempt to call a method with the generated selector on the subject. For example, 'beEqualTo:' calls 'isEqualTo:' has no matcher – instead, Beehive calls 'beEqualTo:' on the subject, providing the expected behaviour.

If you have a method such as -isGreen on your object, you don't need to write a matcher in order for the following to be valid:

    [[object should] beGreen];

Writing Examples
================

Examples
--------

Examples in Beehive are most commonly written using the 'it' function, which accepts a name and a block, as follows:

    it(@"should be green", ^{
        Object *object = [[Object alloc] init];
        [[object should] beGreen];
    });

If the description is ommitted, Beehive will generate a description based on the test content. This works well with subject() blocks, allowing for the following to be valid:

    it(^{ [should beGreen]; });
    
This would output 'should be green'.

If the block is ommitted, Beehive will treat the example as pending:

    it(@"should be green");
    
Specify is an alias for 'it', allowing for the use of any of the following:

    specify(@"should be green", ^{ [[object should] beGreen]; });
    specify(@"should be green");
    specify(^{ [should beGreen]; });

Contexts
--------

Contexts provide a more focused area in which to write tests. Beehive provides the two methods for creating contexts:

    describe(@"Object", ^{...});
    context(@"Object", ^{...});

Use whichever you prefer. The block in either is optional and can be ommitted, which will cause Beehive to treat it as pending in the same way as it does examples.

The best way of describing how contexts work is to provide an example and a sample output. The following is an example in which the contents of each example have been ommitted, but shows the structure and usage of contexts:

    describe(@"The cat", ^{
        it(@"should be named Felix");
  
        context(@"when awake", ^{
            it(@"should be eating");
        });
        
        context(@"when sleeping", ^{
            it(@"should be adorable");
        });
    });
    
The output of executing this would be something like the following:

    The cat
      should be named Felix
      when awake
        should be eating
      when sleeping
        should be adorable
    
Beehive also adds the syntactical function 'when', allowing for the replacement of context(@"when ...") with when(@"sleeping"). The output will be properly formatted. Beehive will treat context(@"when ...") in the same way as it does when(...).

The following code results in the same output as the above example:

    describe(@"The cat", ^{
        it(@"should be named Felix");
  
        when(@"awake", ^{
            it(@"should be eating");
        });
        
        when(@"sleeping", ^{
            it(@"should be adorable");
        });
    });
    
Use whichever you prefer.

Before and after hooks
----------------------

Beehive provides the following functions whose behaviour is identical to their counterparts in any other BDD framework:

    beforeAll(^{ ... });
    afterAll(^{ ... });

    beforeEach(^{ ... });
    afterEach(^{ ... });

    before(^{ ... }); // Identical to beforeEach(^{ ... });
    after(^{ ... }); // Identical to afterEach(^{ ... });
    
Hooks nested in contexts are invoked in the order of outermost to innermost.

Subject
-------

A subject block identifies the object being described in the current context. Expectations made with no subject instead use the result of the closest subject block.

Subjects are created lazily, and nullified at the end of each it() block.

In order to retrieve associations of a subject, the its() function is used. An its() example takes three arguments: a string representation of the property that the block should test against, followed by a optional description, and an optional block that, when ommitted, will cause the example to be treated as pending. The subject of an its() example is the property, identified by the first argument, on the current subject.

Example of usage:

describe(@"The cat", ^{
    subject(id ^{ return [[Cat alloc] init]; });
    
    its(@"name", @"should be Felix (this is optional)", ^{
        // The subject here is the 'name' property on the cat.
        [should be:@"Felix"];
    });
    
    when(@"awake", ^{
        it(^{ [should beEating]; });
    });
        
    when(@"sleeping", ^{
        it(^{ [should beAdorable]; });
    });
});

Let
---

A let() block can be used to provide lazily-created variables to examples that can be accessed using the 'the()' function. All variables created using let() are erased at the end of each example so that they can be recreated during the next.

The let() block used will be the one closest to the current example.

    describe(@"The cat", ^{
        subject(id ^{
            // 'Let' results can be used as subjects:
            return the(@"cat");
        });
    
        let(@"cat", ^{
            return [[Cat alloc] init];
        });
    
        let(@"mouse", ^{
            NSAssert(1, @"This will never get called, as there is a closer let(@\"mouse\") to the example that needs it.");
            return nil;
        });
    
        its(@"name", ^{ [should be:@"Felix"]; });
    
        when(@"awake", ^{
            it(^{ [should beEating]; );
        });
    
        when(@"sleeping", ^{
            it(^{ [should beAdorable]; );
        });
    
        when(@"caught a mouse", ^{
            let(@"mouse", ^{
                return [[Mouse alloc] init];
            });
        
            before(^{
                // 'Let' can be used in hooks:
                the(@"cat").mouse = the(@"mouse");
            });
        
            it(@"should eat it", ^{
                [should beEating:the(@"mouse")];
            });
        });
    });

Shared Examples
---------------

To be discussed.

Mocks and Stubs
===============

To add mocking to Beehive, you can use your favourite mocking library such as [OCMock]() or my recommendation, [MockingBird](), which provides matchers for use with Beehive.

Asynchronous Testing
====================

To be discussed.
