#import "vault.typ": *;
#show: setup
#tag("wad")

= Communication

== HTTP
#flashcard("What does HTTP stand for", "Hypertext Tranfer Protocol")
#flashcard("What is 404", "Not found")

#flashcard("What does HTTPS stand for", "Hypertext Transfer Protocol")
#flashcard("What is HTTPS made up of", "HTTP with TLS")

#flashcard("What are the common HTML method", "POST,GET,PUT,DELETE")\

#flashcard("What is SOAP", "HTTP but with an XML message and a scheme for that message")

#flashcard("Does HTTP have state", "NO!")
#flashcard("How to overcome HTTP statelessness", "Cookies")

== USAP
#flashcard("What does USAP stand for","User agent specific protocols")
#flashcard("What does USAP do", "Wraps the data sent and recivied in HTTP e.g. json, xml")

== Protocols
#flashcard("Other web protocols", "Mailto, News, telnet, ftp")

== AJAX
#flashcard("What does AJAX stand for", "Asyncronous javascript and xml")
#flashcard("What does AJAX allow", "Data fetching without page reload")
#flashcard("What is the UNC way of doing AJAX", "XMLHttpRequest")
  

== XML
#flashcard("What doe XML stand for", "Extensible Markup Language")
#flashcard("Is HTML a subset of XML", "NO html is weird AF")
#flashcard("Is XML case sensitive", "YES")
#flashcard("Does every opening tag need a closing tag", "YES")
#flashcard("Does order matter in XML", "YES")
#flashcard("What is a XML schema", "Way to define expected data structure")

#flashcard("Difference between XHTML and HTML", "XHTML is well formed")

#flashcard("Where is only one node allowed","Root - must be a single root node")

=== Parsing
#flashcard("What does DOM stand for", "Doccument object model")
#flashcard("How does DOM see XML", "Hierarchical model of XML")

#flashcard("What does SAX stand for", "Simple Api for XML")
#flashcard("How does SAX see XML", "Steams data - Event driver parser")
#flashcard("What does event driver parser mean for SAX", "Event triggered when open and closing happen")

#flashcard("Advantages of DOM", "Easy to program, random moving about")
#flashcard("Disadvantages of DOM", "More memory, slower")
#flashcard("Advantages of SAX", "Less memory, faster, dont need everything in memory")
#flashcard("Disadvantages of SAX", "Cannot do all parsing tasks")


#flashcard("Why would you use DOM over SAX and vice versa", "Dom when moving freely, Sax for inorder traversal")

== JSON
#flashcard("What does json stand for", "Javascript object notation")
