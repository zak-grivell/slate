#import "vault.typ":*
#show: setup
#tag("oose")

= Mocking
Mocking is a way to isolate automated tests. For example, you may not want an external API to be called every time tests run, so you replace it with a fake object and controlled return values.

In `Java` this is often done with Mockito:

```java
import static org.mockito.Mockito.*;

ExampleClass mockClass = mock(ExampleClass.class);

when(mockClass.method("an arg")).thenReturn("Some Return Value");
when(mockClass.method("an arg")).thenThrow(new RuntimeException("Err"));
```
If a mocked method is called multiple times, pass multiple values to `thenReturn`.

#flashcard("What is java's mocking framework", "Mockito")
#flashcard("How do you mock in mockito", "create a mock class with `mock` then use `when` and give a `thenReturn` or `thenThrow`")
#flashcard("Why do we mock", "Avoid calling external APIs or long-running code in a test")
#flashcard("How to get multiple different values from a mock", "Pass multiple return values into thenReturn")
#flashcard("What is the import for mocking", "```java import static org.mockito.Mockito.*;```")