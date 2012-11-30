Beehive
=======

Taking inspiration from [Kiwi](), [Cedar](), and [Specta](), Beehive provides an Rspec-like language with which to write specifications with the intention of being used during [Behaviour Driven Development]().

[Kiwi]: https://github.com/allending/Kiwi
[Cedar]: https://github.com/pivotal/cedar
[Specta]: https://github.com/petejkim/specta
[Behaviour Driven Development]: http://dannorth.net/introducing-bdd/

Beehive is built on top of OCUnit, allowing tests to be run from Xcode.

Examples in this document are written assuming that Beehive is being used with [Posit](https://github.com/rdavies/Posit) and [Mockingbird](https://github.com/rdavies/Mockingbird) for expectation and mocking. However, this library can be used with any expectation and mocking libraries, so use whichever you prefer.

Writing Examples
================

Examples
--------

Examples in Beehive are most commonly written using the `it` function, which accepts a name and a block, as follows:

    it(@"should be green", ^{
        Object *object = [[Object alloc] init];
        [[object should] beGreen];
    });

If the block is ommitted, Beehive will ignore the example. The `PENDING` command allows you to mark examples as pending:

    it(@"should be green", PENDING);
    
In addition, `specify` is an alias for `it`.

Contexts
--------

Contexts provide a more focused area in which to write tests. Beehive provides the following methods for creating contexts:

    describe(@"some object", ^{...});
    context(@"some scenario", ^{...});
    when(@"some scenario", ^{...});

The syntactical form `when` acts the same as `context(@"when ...")`.

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

Roadmap
=======

The following features are to be added in [0.2](https://github.com/rdavies/Beehive/issues?milestone=5).

Subject
-------

Note: expectation library must provide support for subjects. [Posit](https://github.com/rdavies/Posit) is one such library.

A subject block defines the object being described in the current context. `its` is used to retrieve associations of a subject.

Example of usage:

    describe(@"The cat", ^{
        subject(id ^{ return [[Cat alloc] init]; });
    
        its(@"name", @"should be Felix", ^{
            // The subject here is the 'name' property on the cat.
            [should beEqualTo:@"Felix"];
        });
    
        when(@"awake", ^{
            it(@"should be eating", ^{ [should beEating]; });
        });
        
        when(@"sleeping", ^{
            it(@"should be adorable", ^{ [should beAdorable]; });
        });
    });

Let
---

`let` is used to provide variables to examples that can be accessed using the 'the()' function:

    describe(@"The cat", ^{
        subject(id ^{ return the(@"cat"); });
        let(@"cat", ^{ return [[Cat alloc] init]; });
        
        its(@"name", @"should be felix", ^{ [should be:@"Felix"]; });
        
        when(@"awake", ^{
            it(@"should be eating", ^{ [should beEating]; );
        });
        
        when(@"sleeping", ^{
            it(@"should be sleeping", ^{ [should beAdorable]; );
        });
        
        when(@"caught a mouse", ^{
            let(@"mouse", ^{ return [[Mouse alloc] init]; });
            before(^{ [the(@"cat") setMouse:the(@"mouse")]; });
            it(@"should eat it", ^{ [should beEating:the(@"mouse")]; });
        });
    });

Shared Examples
---------------

To be discussed.

Asynchronous Testing
--------------------

To be discussed.

License
=======

This project is available under the MIT license. See the LICENSE file for details.
