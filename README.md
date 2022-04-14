# Project Proposal - Extending P0 with Exceptions

**More documentation in details available in [Wiki](https://gitlab.cas.mcmaster.ca/cs4tb3-winter22/group-12/-/wikis/Introduction)**


### Group 12

Team Members:

 - *Meijing Li*
 - *Fanping Jiang*
 - *Kevin Zhou*


## Background
[Exceptions](https://github.com/WebAssembly/exception-handling/blob/master/proposals/exception-handling/Exceptions.md) have recently been added to WebAssembly. The task is to extend the P0 language with **try-catch** and **throw** constructs and extend the compiler to generate WebAssembly exceptions. Exceptions may be thrown explicitly by a throw statement and implicitly when e.g. dividing by zero or indexing an array out of bounds. It is up to you to define the specifics; here is a possible example:
```
compileString("""
procedure sqrt(x: integer) → (r: integer)
    if x < 0 
    then throw 39 
    else 
        r := 1
        while (r × r) ≤ x do
            r := r + 1
        r := r - 1
procedure quadraticsolution(a, b, c: integer) → (x, y: integer)
    var d: integer
        d ← sqrt(a × a - 4 × a × c)
        x, y := (- b + d) div (2 × a), (- b - d) div (2 × a)
program equationsolver
    var a, b, c, x, y: integer
    var done: boolean
        done := false
        while ¬done do
            try
                a ← read(); b ← read(); c ← read()
                x, y ← quadraticsolution(a, b, c)
                write(x); write(y)
            catch 4
                done := true
            catchall
""")
```
## Project Descriptions

### What is `P0`:
Developed by *Dr. Emil Sekerinski* and used in `COMPSCI 4TB3` course, the `P0` language is influenced by Pascal, a language designed for ease of compilation. The main syntactic elements of `P0` are _statements_, _declarations_, _types_, and _expressions_. `P0` takes the inputs of the procedures, compiles the inputs, and then generates WebAssebmbly code.

In this project, we mainly focus on extending the current `P0` to handle the exceptions in the input procedures. We ara able to parse `try-catch statement` and `throw statement` so that `P0` can generate proper WebAssembly exceptions. We will also define three exceptions `Index Out Of Bound`, `Mod By 0` and `Div By 0` to handle the run-time errors that cannot be handled by the old `P0`.



### Exceptions stuctures will be handled in the project: 
- **try-catch** statement:

    There could be multiple `catch` blocks to capture different kinds of exceptions specified by different integer exception tags. 
    ```
        try
            statements
        catch i₁
            statements
        catch i₂
            statements
        ...
        catchall
    ```

- **throw** statement:
    You are able to throw different exceptions specified by the parameter 'i'.
    ```
        throw i
    ```

For Example:
```
procedure foo(x: integer) → (r: integer)
    if x < 0 then throw 0
    else 
        if x < 10 then throw 10
        else r := x 
program test
    var x, a: integer
    try
        x ← read()
        a ← foo(x)
        write(a)
    catch 0
        write(-1)
    catch 10
        write(5)
    catchall
```

**Note: the types of exceptions to be thrown are not restricted in our project. The users are free to choose any integer as the exception tag, except the numbers `110`, `111` and `112` which are pre-defined types and used in the implicit exception handling**
|  Integer Exception Tag |    Exception    |
|------------------------|-----------------|
| 110  | Index out of bound |
| 111  | Division by 0 |
| 112  | Mod by 0 |



### Implementation of Exception handling 
- Explicit Exception Handling
    - *try-catch* statement

      The grammar for *try-catch* block is like:
      ```
      try S catch i₁ T₁ catch i₂ T₂ ... catchall
      ```
    - *throw* statement

      The grammar, in this case, is like:
      ```
      throw i
      ```
      
- Implicit Exception Handling

    For a statement `S` with expected output `o` that could potentially cause the exception `e`, to compile by `P0` or execute it, `S` will either be processed correctly and output `o`, or will output `e` to indicate that there exists an error.

    - Index Out Of Bound
      For expression `arr[i]`, error happens when i is out of the bound. To prevent this, we add 'if-else' to compare i with the array's upper and lower bounds. If it's out of range, we throw exception tag 110.

      For example:
      ```
      var a: [1..2] → integer
      i ← read()
      b = a[i]
      ```
      
      Will be compiled as:
      ```
      var a: [1..2] → integer
      i ← read()
      if (i < 1 or i >= 3) then throw 110 else b = a[3]
      ```
      
    - Division by 0
      For expression `x div y`, error happens when y is 0. To prevent this, we add 'if-else' to compare y with 0. If it's 0, throw exception tag 111.
      
      For example:
      ```
      y ← read()
      b = x div y
      ```
      Will be compiled as:
      ```
      y ← read()
      if (y = 0) then throw 111 else b = x div y
      ```
    In general, `P0` tags all expressions (ie. `a/b`) with potential exceptions, and check every possible steps that may cause exceptions. After compilation, such debugging code will be embedded silently into the compiled program as well.


*Note: more details of the implementation of exception handling will be updated along the process of implementing the project*


<br/>

### Testing Method 
Test cases will be unit tests for the function we added to `P0`. The format will most likely similar to the test cases provided in `P0` for testing other 'built-in' functions. For testing the efficiency, built-in `time` function can be used, or more specifically, the difference between timestamps before and after the code execution is also a way to determine the efficiency.

<br/>

### Documentation 
The specification documentation, or the guides for the project, will be available in the project Wiki page. All the details such as function specifications, installation guide and usage will be given step-by-step to minimize the confusion of the project principles and usage. Besides, a presentation slides will be available after the project is presented at the `4TB3` course, which will help to understand the project in a straightforward manner.

<br/>

### Purpose / Outcome / Changes from the current P0 
The purpose, or the goal of this project is to modify and add functions / classes to the current `P0` libraries so it has the ability to handle exceptions. Ultimately, with all the modifications to the `P0` compiler, it is able to parse and execute codes and expressions listed above and generate WebAssembly exceptions. The changes from the current `P0` compiler will be mainly adding codes to the current version of `P0`, and all of the changes will not affect the basic functionality of `P0`, which means purely adding features to it without losing any of its current ability.

After working on this project, we should not only learned the principles of Exceptions in programming, working on WebAssembly to improve the efficiency of the program execution, but also improve our logical reasoning skills to another level.

<br/>

### Resources <!--(Kevin)-->

 - [WebAssembly/exception-handling](https://github.com/WebAssembly/exception-handling/blob/master/proposals/exception-handling/Exceptions.md)
 - [Guide for IPython core Developers](https://ipython.readthedocs.io/en/latest/coredev/index.html)
 - [Anaconda (for deploying Jupyter to local machine)](https://www.anaconda.com/products/individual)
 - [The Jupyter Notebook - Official Documentation of Jupyter Notebook](https://jupyter-notebook.readthedocs.io/en/stable/)

*Note: Further resources will be added if necessary during the development.*

<br/>


## Division of work <!--(Kevin)-->

 *Note: Since we encourage all of us to participate in every aspects of the project and share the idea together during the group meeting, the division of work can be slightly different from the actual contribution of the project*

- *Meijing*
    - Bridging and generating WebAssembly exceptions
- *Fanping*
    - Rules, definitions and implementations on the Math side of `P0` exceptions
- *Kevin*
    - Test cases, Unit tests, Performance reports, Documentations, Presentation Slides and Scripts

## Weekly schedule <!--(Kevin)-->

|    Date   |              Goal              |
|:---------:|:------------------------------:|
|  9-Mar-22 |   Finish the Project Proposal  |
| 19-Mar-22 |   Modify the Parser  |
| 26-Mar-22 |   Modify P0 to generate WebAssembly Exceptions    |
|  2-Apr-22 |   Keep Modifying P0 and Testing  |
|  9-Apr-22 |   Project Documentation and Slides   |
