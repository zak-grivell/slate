#import "vault.typ":*
#show: setup
#tag("oose")

= Factory Pattern
Used to abstract the complexity of constructing a complex class away from the consumer

```java
class Subject {
  ...
}

class SubjectFactory {
  public static Subject newSubject(...) {
    // logic
    return new Subject();
  }
}
```

#flashcard("What design pattern is
```java
class SubjectXXXX {
  public static Subject newSubject(...) {
    // logic
    return new Subject();
  }
}
```
", "Factory")

#flashcard("Why use factory pattern", "To avoid repetition of creation logic when classes are made in different places")