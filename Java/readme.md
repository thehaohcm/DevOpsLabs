This is a my own documentation related to Java which I collected to reach OCP 17. All these below info would be lack and more advanced because I got some basic knowledge already, and please note that almost info here based on Java 17 version.

1. Fundamentals
  - Static/Final/Private functions cannot be overridden
  - By default, all instance's methods are considered as virtual function, except for static, final and private methods.
  - Abstract methods in abstract class are Pure Virtual Functions
  - A virtual call means that the call is bound to a method at run time and not at compile time.
2. Exception handling & Assertion

  - Notice: 
    + print(exception) just show name of class + message, without any stacktrace. Show stacktrace with **exception.printStackTrace()**
    + Except([Except_1 | Except_2]) with Except_1 and Except_2 have to be different betwee Exception class (ex: except(RuntimeException|IOException e))

3. Java Interfaces
  - Interface can contain public/private/static methods
  - All fields in Interface are **PUBLIC + STATIC + FINAL** => we cannot modify value of Interface's fields in derived classes
  - We can redeclare a static method of parent-interface to be a default method in the sub-interface
  - We can redeclare a default method of parent-interface in the sub-interface
  - Private methods can be invoked only inside the Interface
  - We cannot override static method to non-static and vice-versa.
  - If class A implements Interface I. And class B extends A, and class C extends B
  -   => it means B Is-a A, we can assign a = (B) b
  -   => A referrence of type I, and B extends A, we can cast b to A: a = (B)(I) b
4. Generics and Collections
  - CopyOnWriteArrayList:
      + is extended from ArrayList which supports thread-safe.
      + Cannot use modification methods (Ex: add(),remove() items) via iterator in CopyOnWriteArrayList, it will throw UnsupportedOperationException
  - List and ArrayList:
    + List<?> means list is a List of **everything**, depends on the type of the first item. List<?> is not same as List<Object>. Never has something line "new ArrayList<?>"
    + list.add([index], [value]);
    + Diamond operator <> is always be used in the right hand side of = sign, cannot be used in the left hand side. List<> is invalid, use List<?> instead
    + Arrays.asList() return a mutable list (can add or remove items), whereas List.of() return a immutable list (don't allow to add or remove items)
    + Arrays.asList() allow null item inside, but the list.of() doesn't allow it
  - Collectors:
    + Collectors.partitioningBy(): take a Predicate and return a Collector. This method return 2 groups: 'true' value and 'false' value
  - Dequeue:
    + Works as a reverse action of Queue, LIFO, same as Stack
    + Notice that Stack is a class, whereas Dequeue is an Interface
5. Functional Interface & Lambda Expressions
  - Published in Java 8
  - Functional Interface (FI):
    + FI is an interface which has one and only one abstract method
      ex: Runnable,...
    + There are over 40 FIs established in Java 8, which is located in 'java.util.functions' package
    + But we only have to take care 6 FIs:
      * Function<T,V> => T apply(V v);
      * Consumer<T> => void accept(T t);
      * Supplier<T> => T get();
      * Predicate<T> => boolean test(T t);
      * BinaryOperator
      * UnaryOperator<T> (overloaded Function<T,T>) => T apply(T t)
      * IntFunction<R> => R apply(int value) - extends from Function
  
    + Besides, some FIs you should to take care more in OCP:
      * Comparator<T> => int compare(T o1, T o2);
        . if > 0:  o1 > o2
        . if < 0: o1 < o2
        . if = 0: o1 = o2
6. Lambda Operations on Stream
  - stream().filter(Predicate p)
  - When defining a Lambda with 'var' words, please make sure all vars inside ( ) are always defined with 'var', otherwise, we cannot compile it
  - All intermediate operations (ex: sorted, filter, map) are not be executed until the terminal operation is invoked in the stream. If these intermediate operations are used in the end of stream line code, it will not be executed.
  
7. Migration to a Modular Application
  - Describe module info: 
    ```
    java --describe-module [module-name]
    ```
    ex:
    ```
    java --describe-module java.logging
    ```
    
  - List all dependencies of module:
    ```
    jdeps --print-module-deps -m [module-name]
    ```
    ex:
    ```
    jdeps --print-module-deps -m java.logging
    ```
    
    note: -m can be written with full syntax as: --module
    
    for each module in the java project always have 1 file named module-info.java, which contains exports/requires all neccessary modules''s PACKAGEs need inside the module.
    ex: Module B's packages (ex: example.java.b) and has a module package.b depends on Module A (ex: example.java.a) has a package package.a
    module-info.java in module A
    ```
    module A {
      exports package.a;
    }
    ```
    module-info.java in module B
    ```
    module B {
      requires example.java.a;
    }
    ```
  - Packages are exported and used by using 'exports' and 'requires' keywords in module-info.java
  - Services are exported and used by using 'provides' and 'uses' keywords in module-info.java
8. Service In Modular Application
9. Concurrency
10. Parallel Streams
11. I/O (Fundamentals & NIO2)
12. Database Applications with JDBC
  - execute() return boolean
  - executeUpdate() method return the number of row that have been affected by the query
  - executeQuery() return a ResultSet
  
13. Localization

- Notice: 
  + ***Security, Annotation, Generics & Widecart have been dropped in OCP 17. Please don't focus and take time on them***
  + New topics in OCP 17 (compared with OCP 11):
    - Override methods, including that of an Object class.
        + ***In the previous versions of the exam, the equals and hashcode methods were dropped. We still haven't seen questions on it in the exam.***
    - Switch Expression and no fall through behavior
      + Removing the 'break;' keyword which is always used in any case in switch previously
      + use 'case [option(s)] -> { [logic]; }'
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
      + Published in Java 14
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
      + ***Although Math API has been added in the objectives, we haven't seen any question on it in the exam.***
  
More info: https://enthuware.com/resources/java-certification-faq/220-ocp-java-17-certification-topics