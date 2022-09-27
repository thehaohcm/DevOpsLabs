This is a my own documentation related to Java which I collected to reach OCP 17. All these below info would be lack and more advanced because I got some basic knowledge already, and please note that almost info here based on Java 17 version.

1. Fundamentals
  - Primitive types:
    + byte: -128 to 127
    + short:
    + int:
    + long:
    + float:
    + double:
  - Minimum object size is 16 bytes for modern 64-bit JDK
  - Static/Final/Private functions cannot be overridden
  - By default, all instance's methods are considered as virtual function, except for static, final and private methods which are overridden in the derived classes to performce the polimophism perspective
  - Abstract methods in abstract class are Pure Virtual Functions
  - A virtual call means that the call is bound to a method at run time and not at compile time.
  - In the while loop, the code inside block have to be executed at least once. It means that the condition logic in while( ) is alway reachable (cannot be 'false'). If not, the code cannot be compiled.
  - 'transient' keyword applied for properties in class that doesn't allow properties to be serialized when it persisted to streams of byte. 'transient' is an opposite of 'serializable' interface.
  - Enums (java.lang.Enum)
    + enum can be defined inside a class, or even method and constructor, but for these cases, we cannot defined enum with any access modifier. Enums defined by these ways are implicitly private
    + enum is implicitly final, we cannot extends or use it with 'sealed' keyword
    + although cannot extend enum, but enum can implement interfaces.
    + Cannot override enum's methods
    + Cannot clone an enum
    + toString() enum's method return the enum's name only, we can override it
    + an enum has 2 methods: values() - returns an array of its constant and valueOf(String) - return a constant by matching the String value exactly (with case-sensity) if successful. Otherwise, it throws java.lang.IllegalArgumentException
    + enum's constant has a method named ordinal() return the index (starting with 0) of that constant like an index
    + enum's constant has a method named name(), return name of this constant
    + enum implements Comparable interface, so it can be added into sort collection. The natural order is based on ordinal value of constant
    + unlike class, we cannot access or modify non-static fields in enum's constructor
    + each Enum's constant can be considered as an anonymous subclass of enum, we can also override method of class
      ex:
      ```java
      public enum Pets {
        DOG(1, "D"),    
        CAT(2, "C") 
        {         
          public String getData(){ 
            return type+name; 
          }    
        },    
        FISH(3, "F");    
        int type;    
        String name;       
        Pets(int t, String s) { 
          this.name = s; this.type = t;
        }    
        public String getData() { 
          return name+type; 
        } 
      }
      ```
    + Enum's contants must be declared before anything else (ex: constructor, methods, fields...)
    + Enum's construct is always implicitly private. You cannot make it public or protected
    + we cannot declare fields inside enum with "var" word
  - label in Java (with {} or not) works with break/continue [label_name] as a loop function
  - When we do a mathematical operator (ex: *,/,+,-) between 2 number type integral except 'long' (ex: integer, short, byte,...), the result is always 'integer' with removing the exceeded values after comma 
    + Ex: 7/3 = 2,333334 = 2 in integer in java
    + '''
      short a = 2;
      short b = 3;
      short c = a + b; //this line will be shown error, cannot compile
      => fix: short c = (short) (a + b); 
          or: short c = (short) a + (short) b;
      '''
  - Methods:
    + an Overridding method is allowed to return a sub-type of the return type defined in the overridden method. (Ex: class A has method a() return Iterable, and class B has method a() overrided from class A, but it can return a sub-type like Collection. Because Collection is an sub-interface of Iterable interface)
    + Cannot declare var in parameter of method. ex: void method(var a){ } // compile error
    + The overriden method can have more visibility (ex: super's method() access modifier is default -> devired class's overriden method would be default or protected or public) 
  - Order object blocks run in Java:
    + first, static block called IN THE ORDER they are defined
    + Instance initializer block called IN THE ORDER they are defined
    + Finally, Constructor
    ex:
    ```java
    class A{
      static int VALUE = 1; // because its order is lower than static block, it will be run first.
      public A(){ // constructor (priority order: the last, when the objcect initialized)
        VALUE = 4;
      }
      
      static { // static block (priority order: 1st)
        VALUE = 2;
      }
      
      { // initializer block (priority order: 2st when the object initialized)
        VALUE = 3;
      }
    }
    
    // if not create any object => A.VALUE = 2
    // if create an object => A.VALUE = 4
    ```
  - Operators:
    + == has higher precedence than =
    ex:
    ```java
    boolean a = true;
    int b = 1;
    int b1 = 2;
    if (a = b == b1) // means if (a = (b == b1)) => if (a = (false)), the if expression return false - same value in the left Handside of the expression
    => if(false) => run else statement
    ```

2. Exception handling & Assertion

  - Exceptions
    + IOException -> FileNotFoundException
    + SQLException
  - RuntimeExceptions
    + IllegalArgumentException
    + NullPointerException. Notice that when we print a null object -> it will be shown in screen is 'null'. NullPointerException only thrown when we invoke a method of the null object.
  - Notice: 
    + print(exception) just show name of class + message, without any stacktrace. Show stacktrace with **exception.printStackTrace()**
    + Except([Except_1 | Except_2]) with Except_1 and Except_2 have to be different betwee Exception class (ex: except(RuntimeException|IOException e))
    + if parent class's method throws a checked Exception, and the diverred class overrides this method also, the method not need to be threw these checked exception again. Overrided method is valid without throwing any checked exception
    + the override method of derived class is only thrown the same or a sub-exception class of the supper-class method. Ex: if Supperclass's method() throws IOException -> the Childclass's method() can throw either IOException (by default without declaring) or FileNotFoundException (FileNotFoundException is a subclass of IOException)
    + If the super class have method which throws exception, we don't need to add 'throws [Exception]' in the method define line when override the method in devired classes
    + If the method in super class is not included 'throws' but:
      - the overriden method in devired class is included Exception  => compile error
      - the overriden method in devired class in included RuntimeException => no error
    + with an empty method (without throwing any exception), we can also add 'throws' any RuntimeException and Exception without error compile
    + The try-catch block is added based on an exception thrown by devired class's method (not based on super class' method). That means if super class' method throws Exception, but the devired class method doesn't throw anything => we don't need add try-catch block when calling an instance of devired class
    + A method can be declared/defined with throwing any exception although the body has no throw any exception. No error run or compile

3. Java Interfaces
  - Interface can contain public/private/static methods
  - All fields in Interface are **PUBLIC + STATIC + FINAL** (from Java 8)
    + we cannot modify value of Interface's fields in derived classes
    + cannot define a field in Interface without initialize value
    + cannot define a field with private access modifier
  - We can redeclare a static method of parent-interface to be a default method in the sub-interface
  - We can redeclare a default method of parent-interface in the sub-interface without 'default' keyword in method and without defining method's body
  - Private methods can be invoked only inside the Interface (private method can be static, but cannot define a protected method)
  - We cannot override static method to non-static and vice-versa.
  - If class A implements Interface I. And class B extends A, and class C extends B
  -   => it means B Is-a A, we can assign a = b; and b = (B) a; and can check if(b instanceof A) => true 
  -   => A referrence of type I, and B extends A, we can cast b to A: a = (B)(I) b
  - Cannot cast a **REFERENCE super object** to **subclass type**, we can only cast **a reference SUBCLASS object to SUPPERCLASS type (for invoking)** => the object casted based on reference object. If same type and lower class => no error, otherwise throws an error
  ex:
  ```java
  class A {
  }
  class B extends A{
  }
  class Main{
    public static void Main(String[] args){
      A a = new A();
      B b = new B();
      a = b; // no compile error; no run error
      
      // another example
      A aa = new A();
      B bb = new B();
      bb = (B) aa; //no compile error; but run error
      
      //another example
      A aaa = new A();
      B bbb = new B();
      aaa = bbb; //no compile error; no run error
      bbb = (B) aaa; //no compile error; no run error. Because actually the aaa is assigned to B instance already. We can assign bbb to this B instance which the same object. So it is no error
      
    }
  }
  ```

4. Generics and Collections
  - Array
    + Cannot define an array with specific number length of array when initializing it with {} block
    ```java
    String[] sa = new String[3]{"a","b","c"} // compile error
    String[] sa = new String[]{"a","b","c"} // compiled without error
    ```
  - Iterable (Interface) -> Collection (Interface) 
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
    + some methods:
      - add(Object): add at the last
      - offer(Object): add at the last
        => REMEMBER: ADD() = OFFER() : ADD AT THE TAIL/LAST
      - push(Object): add at the first
      - poll(): remove first
      - remove(): remove first
        => REMEMBER: POLL() = REMOVE() : REMOVE FIRST AT THE HEAD/FIRST
      - Queue's methods:
        + addLast(Object): add at the last
        + addFirst(Object): add at the first
        + offerFirst(Object): add at the first
        + removeFirst(): remove first
        + removeLast(): remove last
  - Map:
    + Map (Interface) -> SortedMap (sub-Interface) -> NavigableMap (sub-Interface) -> TreeMap (class)
    + TreeMap automatically sort items based on key when the new item is added
    + Map.Entry<K,V> pollFirstEntry(): remove and return a key-value mapping associated with the least key in this map, or null if the map is empty (remove the and return the first entity of map)
    + Map.Entry<K,V> pollLastEntry(): remove and return a key-value mapping associated with the greatest key in this map, or null if the map is empty (remove the and return the last entity of map)
    + NavigableMap<K,V> tailMap(K fromkey, boolean inclusive): return a Map contains entities whose key is greater than the key value "fromkey" (or include the entity of key if inclusive parameter = true) - cut and remove the tail of the original map from a key "fromkey" value, return the cut sub-map
  - Notice:
    + Collectors.groupingBy(Function): return a Collector(ex: Map,List,...) that groups all element by matching the Lambda expression in Function Interface. Ex: {C=[S3:C], A=[S1:A, S2:A]}

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
      * BinaryOperator<T> extend BiFunction<T,T,T> => T apply(T t,T t);
      * UnaryOperator<T> (overloaded Function<T,T>) => T apply(T t)
      * IntFunction<R> => R apply(int value) - extends from Function
      * Comparator => int compare(Object obj1, Object obj2);
  
    + Besides, some FIs you should to take care more in OCP:
      * Comparator<T> => int compare(T o1, T o2);
        . if > 0:  o1 > o2
        . if < 0: o1 < o2
        . if = 0: o1 = o2

6. Lambda Operations on Stream
  - stream().filter(Predicate p)
  - When defining a Lambda with 'var' words, please make sure all vars inside ( ) are always defined with 'var', otherwise, we cannot compile it
  - All intermediate operations (ex: sorted, filter, map) are not be executed until the terminal operation is invoked in the stream. If these intermediate operations are used in the end of stream line code, it will not be executed.
  - Some common functions in stream:
    + filter(Predicate) - Intermediate operation
    + map(Function)
    + flatMap(Function)
    + foreach(Consumer)
    + peek(Consumer) - Intermediate opration
    + sorted(Comparator)
    + collect(Collector or Supplier)
    + reduce([default_result_integer_if_stream_empty],BinaryOperator) - terminal operation : do the BinaryOperator function step by step for each item in list stream. ex: if BinaryOperator ex=(e1,e2)->e1+e2; => it means the reduce() method will sum step by step current item with the next item, then return the sum in list stream. Ex: list=1,2,3,4 => reduce((e1,e2)->e1+e2) = 1+2=3, then 3+4= 7 => a result is 7
  - IntStream/LongStream/DoubleStreamm:
    + present a stream of primitive type (int/long/double...)
    + sum() method return a primitive value
    + average() method return OptionalDouble. If the stream is empty or not element => return OptionalDouble will be empty (not 0 or empty)
    + max(Comparator)
  - Intermediate & Terminal Operation:
    + Intermediate Operation: It does not do anything until a terminal operation is invoked on the stream
    + Terminal Operation: execute immediately the method when invoked on the stream

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
    
    note: 
      + -m can be written with full syntax as: --module
      + -p can be written with full syntax as: --module-path
    
    for each module in the java project always have 1 file named module-info.java, which contains exports/requires all neccessary modules''s PACKAGEs need inside the module.
    ex: Module B's packages (ex: example.java.b) and has a module package.b depends on Module A (ex: example.java.a) has a package package.a
    module-info.java in module A
    ```java
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
  - Packages are exported and used by using 'exports' and 'requires' keywords in module-info.java. modules -> use 'requires'
  - Services are exported and used by using 'provides' and 'uses' keywords in module-info.java.
  - one module-info.java file can include both 'require' (for getting packages) and 'uses' (for getting services)
  - there are 2 ways to run a java file inside modele:
    + new way with module-path: java -p [jar_file] -m [module_name]/[classfile_with_fullpackage] (ex: java -p fx.jar -m xyz.fx/com.xyz.fx.Main)
    + legacy way with classpath (ignore the module): java -classpath [jar_file] [classfile_with_fullpackage] (ex: java -classpath fx.jar com.xyz.fx.Main)
  - if one module (1) 'requires another module (2) declared already with 'requires transitive' other modules (3), that means the module (1) doesn't need to 'requires' 2 others modules (2) and (3) inside the module-info.java anymore, just 'requires' only the module (2)

8. Service In Modular Application

9. Concurrency

10. Parallel Streams

11. I/O (Fundamentals & NIO2)
  - Path.resolve() method: public Path resolve(Path other)
    + If the other parameter is an absolute path then this method trivially returns other
    + If other is an empty path then this method trivially returns this pat
    + Otherwise this method considers this path to be a directory and resolves the given path against this path
    + In the simplest case, the given path does not have a root component, in which case this method joins the given path to this path and returns a resulting path that ends with the given path
    ```java
    Path p1 = Paths.get("C:\\example\\test.txt");
    Path p2 = Paths.get("report.pdf");
    System.out.println(p1.resolve(p2)); // it prints C:\\example\test.txt\report.pdf
    
    Path p3 = Paths.get("C:\\example\\report.txt");
    System.out.println(p1.resolve(p3)); // it prints C:\\example\report.pdf
    ```

12. Database Applications with JDBC
  - Always using javax.sql.DataSource instead of java.sql.DataManager in JDBC. DataSource supports more things about ConnectionPool, and improve more performance than the DataManager (by using JDNI)
  - execute() return boolean
  - executeUpdate() method return the number of row that have been affected by the query
  - executeQuery() return a ResultSet
  - Set null for parameter in PrepareStatement by PrepareStatement.setNull([parameter_index-from-1], Type.[VARCHAR/INTEGER/...]) or .setString([paramter_index], null)
  - In a several DB, they automatically save/commit all changes in a period time without any permission from user. To avoid this issue or want to take care all commit in our code, we can turn on/off auto commit of DB by using method Connection.setAutoCommit(boolean)
  - the commit() method is empty parameter, without passing anything into
  - JNDI:
    + stands for Java Naming and Directory Interface
    + common-case used to set up a database connection pool on Java EE application. The application can gain connection by using JNDI name without having to know the connection detail.
    + Pretty similar to a way of DNS, but only affect on DB connection and some service written in Java EE
    + JNDI used with DataSource
    ```java
    Context ctx = new InitialContext();
    DataSource ds = (DataSource) ctx.lookup("java:/comp/env/jdbc/MyLocalDB"); // lookup connection by JDNI name (ex: java:/comp/env/jdbc/MyLocalDB)
    Connection c = dataSource.getConnection(); //no arguments
    ```

13. Localization
  - LocalDateTime.of(YEAR,MONTH,DATE,HOUR,MINUTE)
  - ZoneDateTime.of(LocalDateTime,ZoneId.of(COUNTRY_STRING))

- Notice: 
  + ***Security, Annotation, Generics & Widecart have been dropped in OCP 17. Please don't focus and take time on them***
  + New topics in OCP 17 (compared with OCP 11):
    - Override methods, including that of an Object class.
        + ***In the previous versions of the exam, the equals and hashcode methods were dropped. We still haven't seen questions on it in the exam.***
    - Switch Expression and no fall through behavior
      + Removing the 'break;' keyword which is always used in any case in switch previously
      + use 'case [option(s)] -> { [logic]; }'
        ```java
        switch(dayOfWeek){
          case 'Monday' -> { s.o.println("This is Monday"); }
          ...
        }
        ```
      + all variables are valid inside switch() block, without any problem in different 'case'
    - Multiline Strings / Text blocks
      + Instead of using "\n" to preresent a new line in Java code previously, now we can use """ and write a text with new line to be more readable
        ```java
        String html = """
        <html>
          <body>
            <h1>Hello World</h1>
          </body>
        </html>
        """
        ```
        Ex:
        ```java
        String hello = """
        EH""" // hello.lines.count() = 1, the output actually is "EH", no new line after H
  
        String hello = """
        EH
        """ // hello.lines.count() = 1, but actually the output is: "EH\n", still have new line after H
  
        String hello = """
        EH
        E""" // hello.lines.count() = 2, the output actually is "EH\nE", new line after H
        ```
      + Notice: the backslash charater ("\") when appended into the last of line will remove the breaking line ("\n") of multiline string.
        ```java
        String hello = """
        Hello\
        World""" // output: HelloWorld
        ``` 
    - Records
      + Published in Java 14
      + This is a new way to create a DataModel class without defining a class, properties and methods inside
      + All properties inside the Records are 'final' (cannot modify during running)
      + The public instructor with all parameters will be created mapped with all properties we defined in Record
      + We can add more new method, but cannot add new property into Record's body
        ```java
        public record Student (int Id, String firstName, String lastName) {  }
        ```
    - Sealed classes / interfaces
      + Published in Java 16
      + A new way to grant permission to parent class that only allow some specific subclasses to extend it
      + Use keyword 'selead class/interface [class_name/interface_name]' together with  'permits' [divered_class/divered_interface]
      + The derived classes can be defined with one of keywords: 'non-sealed' / 'final' (for interface, only allow 'non-sealed')
        ```java
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
      + If the sealed class or interface not added with 'permits' keyword, that means the class/interface has been extended/implemented by another already. Otherwise, the compiler will show error
      + If the class declared in 'permits' doesn't use either 'sealed' or 'non-sealed' => compile error
    - 'instanceof' and pattern matching
    - API Changes - method additions - Date/Time API
      + ***Although Math API has been added in the objectives, we haven't seen any question on it in the exam.***
  
More info: https://enthuware.com/resources/java-certification-faq/220-ocp-java-17-certification-topics
