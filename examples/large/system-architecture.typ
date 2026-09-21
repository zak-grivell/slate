#import "vault.typ": *;
#show: setup
#tag("wad")

= System Architecture
#flashcard("What are the layers in a three teired architecture", "Client, Middlewear, Database")

#flashcard("What does MVC stand for", "Model, View, Controller")
#flashcard("What is a model in MVC", "Source of data e.g. Database")
#flashcard("What is a view in MVC", "Determines how things are rendered")
#flashcard("What is a controller in MVC", "Takes the models and turns it into what the view wants")

#flashcard("In django what repersents MVC", "Models are models, views are templates and controllers are views")

#flashcard("Is Django the client, the middle wear or the database", "Middlewear")

#flashcard("Describe the internal flow of django", "#image(\"../djangointernal.png\")")

#flashcard("What is load balancing", "Distibuting requests between servers")
#flashcard("WHat are the two load balancing strategys", "DNS roating IP, Dedicated LB server")
#flashcard("What are the advantages of tierd servers", "Encapsulation, Flexibilty, Security, Scalabilty")
