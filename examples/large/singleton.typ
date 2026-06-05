#import "vault.typ":*
#show: setup
#tag("oose")

= Singleton Pattern
Used to only have one instance of a class

#diagram(
  spacing: (18mm, 10mm),
  node-stroke: luma(80%),
  edge-stroke: luma(80%),
  
  node((0, 0), [*Client*], name: <c>, height: 2cm, width: 2cm),
  node((2, 0), [*Singleton*], name: <s>, height: 2cm, width: 2cm),

  edge(<s>, "-|>", <s>, label: [Singleton singleton], bend: 135deg),
  edge(<c>, "-|>", <s>, label: [getInstance()]),
)

```java
class Singleton {
  private static Singleton singleton;

  private Singleton() {}

  public static Singleton getInstance() {
    if (singleton == null) {
      singleton = new Singleton();
    }

    return singleton;
  }
}
```

#flashcard("What is the singleton pattern", "Pattern where a class has exactly one shared instance")
#flashcard("What are the modifiers on the singleton instance variable", "private static")
#flashcard("What are the modifiers on the singleton getInstance method", "public static")
#flashcard("What design pattern is this", "
#diagram(
  spacing: (18mm, 10mm),
  node-stroke: luma(80%),
  edge-stroke: luma(80%),
  
  node((0, 0), [*Client*], name: <c>, height: 2cm, width: 2cm),
  node((2, 0), [*XXXX*], name: <s>, height: 2cm, width: 2cm),

  edge(<s>, \"-|>\", <s>, label: [XXXX xxxx], bend: 135deg),
  edge(<c>, \"-|>\", <s>, label: [getInstance()]),
) 
")
#flashcard("Describe the implementation of the singleton class", "
```java
class Singleton {
  private static Singleton singleton;

  private Singleton() {}

  public static Singleton getInstance() {
    if (singleton == null) {
      singleton = new Singleton();
    }

    return singleton;
  }
}
```
")
#flashcard("Why use the singleton pattern", "To provide one controlled global access point to a shared instance")