#import "vault.typ": *;
#show: setup
#tag("wad")

== HTML
How to meet ladies/Hypertext markup language

#flashcard("What does HTML stand for", "Hypertext markup language")

#flashcard("What does the <html> tag do?", "Doccument root")
#flashcard("What does the <head> tag do?", "Declares invisible imports and settings")
#flashcard("What does the <body> tag do?", "Has all the website content in it")

#flashcard("What are the heading tags", "<h1> -> <h6>")
#flashcard("What is a <p> tag", "Paragraph")
#flashcard("What is a <a> tag", "Anchor - link")

#flashcard("What does a <li> do?", "List item")
#flashcard("What does a <ul> do?", "Unordered list")
#flashcard("What does a <ol> do?", "Ordered List")
#flashcard("What does a <br> do?", "Line break")

#flashcard("What does a <div> do?", "Divide the page / Legit everything")
#flashcard("What does a <span> do?", "Group inline")

== CSS
#flashcard("What does CSS stand for", "Cascading Style Sheets")
#flashcard("What absolute length units are there in CSS", "px (only correct), in, cm, mm, pt")
#flashcard("What relative length units are there in CSS", "em - root font size, rem - font size of parent")

#flashcard("What are the three places for css", "Inline (style=\"\"), Embedded <style>...</style> and External <link rel=stylesheet href=...>")
#flashcard("What element and attrs are used for external css", "<link rel=stylesheet href=path>")

#flashcard("What is an id selector in CSS", "#")
#flashcard("What is an class selector in CSS", ".")
#flashcard("What is a decendant selector in CSS", ".class1 <space> .class2")
#flashcard("What allows for multiple class requirements in css", ".class1.class2")
#flashcard("What allows for multiple class options in a css rule", ".class1, .class2")

#flashcard("What is used to rank css specificty", "An tuple of (#no ids, #no classes, #no tag/psudoelement)")

#flashcard("What is the ranking of the CSS tuples", "Ranked with most significant digit first then most recent if multiple defined")

#flashcard("When does inline css take precident", "Always")

#flashcard("What is the float property", "Makes an item align to the side in its avaible space")
#flashcard("What are the positioning properties in css", "Static; Fixed; Relative; Absolute")
#flashcard("What is static positioning", "Default - follows normal flow with no effect from left right etc")
#flashcard("WHat is absolute positioning", "Positioned to first non static parent")
#flashcard("What is fixed positioning", "Relative to browser window not effected by scrolling or other things")
#flashcard("What is relative positionsing", "Relative to normal static position")

#flashcard("What is the CSS box model", "Margin (outer), border, Padding, Element")

== DOM
#flashcard("What does the DOM stand for", "Doccument Object Model")
#flashcard("What is the DOM", "Way browsers repersent HTML as Node and children")
#flashcard("What are the different nodes in the DOM", "Doccument, Element, Attribute, Text, Comments")

#flashcard("What is the innerHTML", "Textual repersentation in XML(ish) of DOM")
#flashcard("WHat is the nodeName", "Element name if element otherwise the #text for text node etc")
#flashcard("What is the nodeValue", "The text for a text node, etc but null for element")

#flashcard("Advantages of DOM", "Easy to traverse, Modifiable, Is the standard")
#flashcard("Disadvatages of DOM", "Slow to construct, Struggles to repersent some things")

== Interactions
#flashcard("How are interactions handled in JS", "Events")
#flashcard("What is an EventTarget", "The node an event came from")
#flashcard("Differences between Event capture and event bubbling", "Capture gets caught by root and then passed to relevent object for local handling vs bubbling caught locally but sent for global handling")
#flashcard("What does JS use bubbling or capture", "BOTH! (Bubbling used more often tho)")

== REGEX
#flashcard("What does \$ do in regex", "End of string")
#flashcard("What is regex search", "Find starting pos of first match")
#flashcard("What is regex exec", "Returns the first match")
#flashcard("What is regex test", "True if match found else false")

== JTRASHQUERY
#flashcard("What does the \$(x) do in JQUERY", "Get element with query x")
#flashcard("How does JQUERY handle events", ".click(callback)")
