#import "vault.typ": *;
#show: setup
#tag("wad")

= Server

== MVC
#flashcard("Advantages of MVC", "Maintainabilty, Reusability")
#flashcard("Disadvatages of MVC", "Overhead, Debugging, Knowlage of design patterns")
#flashcard("What do views do", "Determine how data is presented")
#flashcard("What do models do", "Encapsulate the data")
#flashcard("What do controllers do", "Handle interactions and processing")

== Frameworks
#flashcard("What is a framework", "Provide default functionality & Shortcuts")
#flashcard("Advantages of frameworks", "Rapid, Reduce boilterplate, Reliability")
#flashcard("Disadvantages of frameworks", "Code bloat, Poor documentation, Performance")

#flashcard("Difference between frameworks and libraries", "Your code calles libraries where frameworks call your code")

== Templates
#flashcard("How to do branching in templates", "{% if cond %} ... {% else %} ... {% endif %}")
#flashcard("How to do loops in templates", "{% for name in obj } ... {% endfor %}")
#flashcard("How to insert a varible in templates", "{{name}}")

== URLS
=== Scheme
Scheme, Authority, Path
#flashcard("What are the three parts of a url", "Scheme URL, Authority, Path")
#flashcard("In https://developer.mozilla.org/en-US/docs/Learn_web_development/ What is the scheme, the authrity and the path", "https, developer.mozilla.org, en-US/docs/Learn_web_development")
#flashcard("What is a query parameter", "?val=x%20num=2")
#flashcard("What is a fragment identifier", "Identifies a sub part of a page with #sectionA")

=== Parameters
#flashcard("What are URL parameters", "Placeholders in URLS that can be read programttically")
#flashcard("How are url params delcared", "<type:name>")

=== Linking
#flashcard("Why is it bad to hardcode urls", "High Coupling")
#flashcard("In templates how do you link to a named url", "url {name} {param1} {param2}")

== Static Files
#flashcard("What are static files", "Things that wont change dyanmically e.g. css, js, images")

== Models
#flashcard("What is a model", "A repersentation of a database object")
#flashcard("What is a population script", "Something to populate database with testing data")

=== Er

#flashcard("What is a ER diagram", "Visual Way of repersneting a DB schema")
#flashcard("How do you repersent a table in ER diagram", "Rectangle")
#flashcard("How do you repersent a relationship in ER diagram", "Diamond")
#flashcard("How do you repersent cardianlity in ER diagram", "1, M, N")
#flashcard("How do you repersent a fielf in ER diagram", "Elipse if not compressed notation")

=== Djagno Repersentation
#flashcard("How do you do a forign key in django", "models.ForignKey(Model)")
#flashcard("How can something be unique django", "models.Type(unque=True)")
#flashcard("What is a slug field", "a slUg Feild = a-slug-feild")
#flashcard("How to do many to many django", "models.ManyToManyField(Model)")

#flashcard("What is an ORM", "Object relational mapper - takes db tables and turns into py objects")
