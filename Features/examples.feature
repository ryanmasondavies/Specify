Feature: examples

  Beehive is a DSL for creating executable examples of how code is expected to
  behave, organized in groups. It uses the words "describe" and "it" so we can
  express concepts like a conversation:
    "Describe an account when it is first opened."
    "It has a balance of zero."
    
  Scenario: one example
    Given the spec:
      """
      it(@"should do something", ^{
      });
      """
    When I run the spec
    Then the output should contain "should do something"
    
  Scenario: one nested example
    Given the spec:
      """
      describe(@"something", ^{
          it(@"should do something", ^{
          });
      });
      """
    When I run the spec
    Then the output should contain:
      """
      something
        should do something
      """
