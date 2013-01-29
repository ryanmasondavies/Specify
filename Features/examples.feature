Feature: Basic Structure
  In order to easily define how my system should behave
  As a developer
  I want to be able to write examples
  
  Background:
    Given I have a spec suite
      And I have added Specify as a dependency using CocoaPods
      And I have successfully installed the pods
  
  Scenario: One Group, One Example
    Given the spec suite has the spec:
      """
      #import <Specify/Specify.h>
      SpecBegin(Examples)
      it(@"should be fat", ^{});
      it(@"should be tall", ^{});
      SpecEnd
      """
     When I run the specs
     Then the following examples should have passed:
      | name           |
      | should be fat  |
      | should be tall |
      And there should have been no failures
