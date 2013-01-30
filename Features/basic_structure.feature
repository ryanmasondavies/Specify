Feature: Basic Structure
  In order to easily define how my system should behave
  As a developer
  I want to be able to write examples
  
  Background:
    Given I have a spec suite
      And I have added Specify as a dependency using CocoaPods
      And I have successfully installed the pods
  
  Scenario: One group, one example
    Given the spec suite has the spec:
      """
      #import <Specify/Specify.h>
      SpecBegin(OneGroupOneExample)
      describe(@"something", ^{
        it(@"should do something", ^{
        });
      });
      SpecEnd
      """
     When I run the specs
     Then the following examples should have passed:
        | name                          |
        | something should do something |
      And there should have been no failures
      
  Scenario: Nested example groups using context()
    Given the spec suite has the spec:
      """
      #import <Specify/Specify.h>
      SpecBegin(NestedExampleGroupsUsingContext)
      describe(@"something", ^{
        context(@"in one context", ^{
          it(@"should do one thing", ^{
          });
        });
        context(@"in another context", ^{
          it(@"should do another thing", ^{
          });
        });
      });
      SpecEnd
      """
    When I run the specs
    Then the following examples should have passed:
       | name                                                 |
       | something in one context should do one thing         |
       | something in another context should do another thing |
  
   Scenario: Nested example groups using when()
     Given the spec suite has the spec:
       """
       #import <Specify/Specify.h>
       SpecBegin(NestedExampleGroupsUsingWhen)
       describe(@"something", ^{
         when(@"in one context", ^{
           it(@"should do one thing", ^{
           });
         });
         when(@"in another context", ^{
           it(@"should do another thing", ^{
           });
         });
       });
       SpecEnd
       """
     When I run the specs
     Then the following examples should have passed:
        | name                                                      |
        | something when in one context should do one thing         |
        | something when in another context should do another thing |
