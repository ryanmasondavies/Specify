Specify
=======

Specify helps you describe behaviour in conversational terms.

It was developed out of a personal need for a simple BDD library - more lightweight and extendable than the alternatives, with the addition of extra DSL functions to simplify writing examples.

Specify makes use of the dynamic nature of blocks to define DSL methods like `it()` and `describe()`:

```
describe(@"the stack", ^{
    __block Stack *stack;

    before(^{
        stack = [[Stack alloc] init];
    });

    context(@"when newly initialized", ^{
        it(@"is empty.", ^{
            [[[stack popObject] should] beNil];
        });
    });
    
    context(@"when 1 object is pushed", ^{
        before(^{
            [stack pushObject:@1];
        });
        
        describe(@"first pop", ^{
            it(@"returns the object.", ^{
                [[[stack popObject] should] beEqualTo:@1];
            });
        });
    
        describe(@"second pop", ^{
            it(@"returns nil", ^{
                [stack popObject];
                [[[stack popObject] should] beNil];
            });
        });
    });
});
```

This makes implementing custom DSL's significantly easier. If you're more comfortable using the term `test` to define examples, go ahead and define it: `void(^test)(NSString *, INLVoidBlock) = it;`, then use it:

```
void(^test)(NSString *, INLVoidBlock) = it;
describe(@"the stack", ^{
    test(@"stack is initially empty.", ^{
        [[[stack popObject] should] beNil];
    });
});
```

After all, if [the language][Introducing BDD] is so important, we should be able to say whatever we want.

Specify provides some additional convenience functions to help with writing specs. To view the full list of functions and examples, see the [Wiki][].

[Inline]: http://www.github.com/rdavies/Inline
[Introducing BDD]: http://dannorth.net/introducing-bdd/
[Wiki]: https://github.com/rdavies/Specify/wiki

Making Expectations
-------------------

The above examples use the 'should' syntax provided by [Posit][], but you can use any frameworks which support SenTestingKit, including [Expecta][]. You can also use the default SenTestingKit macros:

```
it(@"is empty.", ^{
    // SenTestingKit syntax
    STAssertNil([stack popObject], @"Popping an empty stack should return nil."); // SenTestingKit
    
    // Posit syntax
    [[[stack popObject] should] beNil];
    
    // Expecta syntax
    expect([stack popObject]).to.beNil();
});
```

[Posit]: https://github.com/rdavies/Posit
[RSpec]: http://rspec.info
[Expecta]: https://github.com/petejkim/expecta

Installation
============

Specify is installed using [CocoaPods][] by adding `pod 'Specify', '~> 0.1.0'` to your Podfile.

[CocoaPods]: https://github.com/CocoaPods/CocoaPods

License
=======

    Copyright (c) 2013 Ryan Davies
    
    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:
    
    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.
    
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
