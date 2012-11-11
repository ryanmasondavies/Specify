Feature: examples

  Beehive is a DSL for creating executable examples of how code is expected to
  behave, organized in groups. It uses the words "describe" and "it" so we can
  express concepts like a conversation:
    "Describe an account when it is first opened."
    "It has a balance of zero."
    
  Scenario: one example
    Given a test suite
      And the spec:
      """
      it(@"should perform basic math", ^{
          STAssertTrue((1+2) == 3, @"failed at basic math");
      });
      """
    When I run the tests
    Then the output should contain "should perform basic math"
