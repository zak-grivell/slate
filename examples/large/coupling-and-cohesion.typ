#import "vault.typ":*
#show: setup
#tag("oose")

= Coupling
Coupling is how closely tied one piece of a program is to another

Types:
- Content - One modifies data of another 
- Common - Multiple modules use same data
- External - Coupling to external APIs & such
- Control - Another module handling control flow
- Stamp - Several modules share a composite data structure
- Data - Modules sharing data through parameters

#flashcard("What is coupling", "How closely tied modules are to each other")
#flashcard("How much coupling do you want", "Low")
#flashcard("Why is high coupling bad", "Changes in one module may break others")

#flashcard("What is content coupling", "One module can modify the data of another module")

#flashcard("What is common coupling", "Multiple modules have shared data like a global data structure")

#flashcard("What is external coupling", "Coupling to external APIs & such")

#flashcard("What is control coupling", "Another module handling control flow")

#flashcard("What is stamp coupling", "Several modules share a complete data structure")

#flashcard("What is data coupling", "Modules sharing data through parameters")

#flashcard("What is the hierarchy of coupling", "Content > Common > External > Control > Stamp > Data")

= Cohesion
Cohesion is how much the elements in a module work together for a single purpose

#flashcard("What is cohesion", "How much each module works together for a single purpose")
#flashcard("How much cohesion do you want", "High")
#flashcard("Why is low cohesion bad", "Difficult to find what does what and makes flow unclear")

There are many levels that I will add if seem to come up in past papers

= Solutions

- REST Services - A way to reduce coupling by using a standard interface for communication
- Messages - Pattern to have standard messages for communication between modules while reducing coupling
- Microservices - A way to reduce coupling by breaking a system into smaller, independent services
- Web Components - A way to reduce coupling by creating reusable components that can be used across different projects
- Feature Switches - A way to reduce coupling by allowing features to be turned on and off without changing code
- MonoRepos - A way to reduce coupling by having all code in a single repository, making it easier to manage dependencies and changes

#flashcard(
  "What are REST services and how do they help coupling and cohesion",
  "A way to reduce coupling by using a standard interface for communication",
)
#flashcard(
  "What are messages and how do they help coupling and cohesion",
  "Pattern to have standard messages for communication between modules while reducing coupling",
)
#flashcard(
  "What are microservices and how do they help coupling and cohesion",
  "A way to reduce coupling by breaking a system into smaller, independent services",
)
#flashcard(
  "What are web components and how do they help coupling and cohesion",
  "A way to reduce coupling by creating reusable components that can be used across different projects",
)
#flashcard(
  "What are feature switches and how do they help coupling and cohesion",
  "A way to reduce coupling by allowing features to be turned on and off without changing code",
)
#flashcard(
  "What are monorepos and how do they help coupling and cohesion",
  "A way to reduce coupling by having all code in a single repository, making it easier to manage dependencies and changes",
)