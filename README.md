Beehive
=======

Taking inspiration from [Kiwi](), [Cedar](), and [Specta](), Beehive provides an Rspec-like language with which to write specifications with the intention of being used during [Behaviour Driven Development]().

[Kiwi]: https://github.com/allending/Kiwi
[Cedar]: https://github.com/pivotal/cedar
[Specta]: https://github.com/petejkim/specta
[Behaviour Driven Development]: http://dannorth.net/introducing-bdd/

Beehive is built on top of OCUnit, allowing tests to be run from Xcode.

All examples are written assuming that Beehive is being used in conjunction with [Posit](https://github.com/rdavies/Posit) and [Mockingbird](https://github.com/rdavies/Mockingbird) for expectation and mocking. However, this library can be used with any expectation and mocking libraries, so use whichever you prefer.

This library is a work in progress, and so the API may be subject to simplification and potentially drastic change.

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

Note: expectation library must provide support for subjects. (Posit)[] is one such library.

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

Asynchronous Testing
--------------------

To be discussed.

License
=======

This project is available under the MIT license. See the LICENSE file for details.
