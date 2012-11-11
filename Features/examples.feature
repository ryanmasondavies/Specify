Feature: examples

  Beehive is a DSL for creating executable examples of how code is expected to
  behave, organized in groups. It uses the words "describe" and "it" so we can
  express concepts like a conversation:
    "Describe an account when it is first opened."
    "It has a balance of zero."
    
  Scenario: one example
    Given the spec:
      """
      it(@"should recognise examples", ^{
      });
      """
    When I run the tests
    Then the output should contain "should recognise examples"
