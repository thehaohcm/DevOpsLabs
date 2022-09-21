This is a my own documentation related to Java which I collected to reach OCP 17. All most these below would be lack and more advanced because I got some basic knowledge already, and please note that almost info here baed on Java 17 version.

1. Fundamentals
2. Exception handing & Assertion
3. Java Interfaces
4. Generics and Collections
5. Functional Interface & Lambda Expressions
6. Lambda Operations on Stream
7. Migration to a Modular Application
8. Service In Modular Application
9. Cocurrency
10. Parallel Streams
11. I/O (Fundamentals & NIO2)
12. Database Applications with JDBC
13. Localization

- Notice: 
  + Security, Annotation, Generics & Widecart have been dropped in OCP 17. Please don't focus and take time on them
  + New topics in OCP 17 (compared with OCP 11):
    - Override methods, including that of an Object class.
        ***In the previous versions of the exam, the equals and hashcode methods were dropped. We still haven't seen questions on it in the exam.***
    - Switch Expression and no fall through behavior
      + Removing the 'break;' keyword which is always used in any case in switch previously
      + use 'case [option(s)] -> { [logic]; } 
        ```
        switch(dayOfWeek){
          case 'Monday' -> { s.o.println("This is Monday"); }
          ...
        }
        ```
    - Multiline Strings / Text blocks
      + Instead of using "\n" to preresent a new line in Java code previously, now we can use """ and write a text with new line to be more readable
        ```
        String html = """
        <html>
          <body>
            <h1>Hello World</h1>
          </body>
        </html>
        """
        ```
    - Records
      + This is a new way to create a DataModel class without defining a class, properties and methods inside
      + All properties inside the Records are 'final' (cannot modify during running)
      + The public instructor with all parameters will be created mapped with all properties we defined in Record
      + We can add more new method, but cannot add new property into Record's body
        ```
        public record Student (int Id, String firstName, String lastName) {  }
        ```
    - Sealed classes
      + Published in Java 16
      + A new way to grant permission to parent class that only allow some specific subclasses to extend it
      + Use keyword 'selead class [class_name]' together with  'permits' [delivered_class]
      + The derived classes must be defined with one of keywords: 'nonsealed' / 'final'
        ```
        public sealed class ParentClass permits SubClass1, SubClass2{
          ...
        }

        public non-sealed class SubClass1 extends ParentClass { // works
          ...
        }
        
        public final class SubClass2 extends ParentClass { // works
          ...
        }
        
        public class SubClass3 extends ParrentClass { // not work
          ...
        }
        ```
    - 'instanceof' and pattern matching
    - API Changes - method additions - Date/Time API
      ***Although Math API has been added in the objectives, we haven't seen any question on it in the exam.***
  
More info: https://enthuware.com/resources/java-certification-faq/220-ocp-java-17-certification-topics
