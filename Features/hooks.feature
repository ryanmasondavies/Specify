Feature: Hooks
  In order to provide a context for examples
  As a developer
  I want to be able to write hooks
  
  Background:
    Given I have a spec suite
      And I have added Specify and Expecta as dependencies using CocoaPods
      And I have successfully installed the pods
  
  Scenario: Before hooks
    Given the spec suite has the spec:
      """
      #import <Specify/Specify.h>
      #define EXP_SHORTHAND
      #import <Expecta/Expecta.h>
      SpecBegin(Things)
      describe(@"initialized in before()", ^{
        __block NSMutableArray *things;
        before(^{ things = [NSMutableArray array]; });
        it(@"should have 0 things", ^{
          expect(things).to.haveCountOf(0);
        });
        it(@"should be able to accept new things", ^{
          [things addObject:[NSObject new]];
        });
        it(@"should not share state across examples", ^{
          expect(things).to.haveCountOf(0);
        });
      });
      SpecEnd
      """
     When I run the specs
     Then the following examples should have passed:
        | name                                                           |
        | initialized in before() should have 0 things                   |
        | initialized in before() should be able to accept new things    |
        | initialized in before() should not share state across examples |
      
  Scenario: Before and after hooks are run in order
    Given the spec suite has the spec:
      """
      #import <Specify/Specify.h>
      #define EXP_SHORTHAND
      #import <Expecta/Expecta.h>
      SpecBegin(BeforeAndAfterHooks)
      before(^{ NSLog(@"Before"); });
      after(^{ NSLog(@"After"); });
      it(@"gets run in order", ^{});
      SpecEnd
      """
     When I run the specs
     Then the output should match:
       """
       .* Before
       .* After
       """
      