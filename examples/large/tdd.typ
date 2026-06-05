#import "vault.typ":*
#show: setup
#tag("oose")

= Test Driven Development
Rather than writing code first, write tests to the specification. This helps avoid over-coding the problem because you write the minimum needed to pass the tests. It also makes changes easier because you have tests to compare against.

Steps:
- Write tests which fail
- Write code to make the tests pass
- Refactor and ensure the tests still pass


#flashcard("What is TDD", "Test Driven Development - Write tests first then code")
#flashcard("Advantages of TDD", "Only code to requirements; easier to refactor because of automated tests")
#flashcard("How many concepts should each test check", "One")
#flashcard("What are assertions", "The checks within tests - assertEq, assertTrue, assertFalse")