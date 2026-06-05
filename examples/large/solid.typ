#import "vault.typ":*
#show: setup
#tag("oose")

= SOLID

== Single Responsibility principle
Each class should have *one* responsibility so there is no more than one reason for a class to change

#flashcard("What is the S in SOLID", "Single responsibility principle")
#flashcard("What is the single responsibility principle", "Classes should have one responsibility")
#flashcard("Why use the single responsibility principle", "Easier to understand; easier to test; one change, one impact")

== Open Closed Principle
Open to extension, closed to modification

#flashcard("What is the O in SOLID", "Open closed principle")
#flashcard("What does the Open Closed Principle mean", "Open to extension, closed to modification - new features can be added without changes, should not change internals and break them")
#flashcard("Why use the open closed principle", "Stability and flexibility")

== Liskov substitution principle
Any subclass should be able to be passed in like its the parent class and should work as expected

#flashcard("What is the L in SOLID", "Liskov substitution principle")
#flashcard("What is the Liskov substitution principle", "A subclass should always be able to be passed instead of parent class")
#flashcard("Why use the Liskov substitution principle", "Polymorphism, reliability, predictability")

== Interface segregation principle
Many specific interfaces are better than a general interface. So client should not be forced to depend on an interface they don't use

#flashcard("What is the I in SOLID", "Interface segregation principle")
#flashcard("What is the interface segregation principle", "Many specific interfaces are better than a general interface")
#flashcard("Why use the interface segregation principle", "Decoupling and flexibility")

== Dependency Inversion Principle
A class should rely only on other interfaces for the features it requires

#flashcard("What is the D in SOLID", "Dependency Inversion Principle")
#flashcard("What is the dependency inversion principle", "High-level code should depend on abstractions, not concrete classes")
#flashcard("Why use the dependency inversion principle", "Loose coupling, flexibility, maintainability")