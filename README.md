<!---
By **Wednesday, March 9**, you have to submit to the GitLab repository a plan with (1) a description of the project, (2) all the resources to be used (textbooks, manuals, software, articles, etc.), (3) division of work, (4) weekly schedule. The project plan should have **2 - 3 pages**. Use markdown, not Word; use LaTeX only if you need the math features. All group members have to commit to the repository for the plan to receive a grade. The description has to elaborate on the problem, how the implementation will be tested and measured (if efficiency is the goal), how it will be documented, and what insight you hope to gain from it. You will receive feedback on the project plan.
-->

# Project Proposal - Extending P0 with Exceptions
### Group 12 - (Group Name *TBA*)

Team Members:

 - *Meijing Li*
 - *Fanping Jiang*
 - *Kevin Zhou*


### Implementation:
- Based on the version of `p0` in ch5
- In SC, define symbols: `EXPLICITEXCEPTION = 52; IMPLICITEXCEPTION = 53`; add keyword `'throw': EXPLICITEXCEPTION`
- In ST: create type `Excp` for exception:
    ```
    class Excp:
    def __init__(self, excpType, message=""):
        self.excpType, self.message = excpType, message
    def _str_(self):
        return 'Self-defined Exception(type = ' + str(self.excpType) + ', message = ' + \
               self.message + ')'
    ```
    - excpType ∈ {EXPLICITEXCEPTION, IMPLICITEXCEPTION}
    - message a string of explanation(optional)

- In `P0`:
    - Add `throw`. `try-catch`to statement:
    ```
    statement ::=
        ...
        "throw"
        "try" statementSuite "catch" statementSuite
    ```


- **TODO** in CGWAT:
    - `genExcp()` (if the interface is changed, also update the use of the function in `P0`)
    - ...





## Background
[Exceptions](https://github.com/WebAssembly/exception-handling/blob/master/proposals/exception-handling/Exceptions.md) have recently been added to WebAssembly. The task is to extend the P0 language with **try-catch** and **throw** constructs and extend the compiler to generate WebAssembly exceptions. Exceptions may be thrown explicitly by a throw statement and implicitly when e.g. dividing by zero or indexing an array out of bounds. It is up to you to define the specifics; here is a possible example:
```
procedure sqrt(x: integer) → (r: integer)
    if x < 0 then throw else ...

procedure quadraticsolution(a, b, c: integer) → (x, y: integer)
    var d: integer
        d ← sqrt(a × a - 4 × a × c)
        x, y := (- b + d) div (2 × a), (- b - d) div (2 × a)
program equationsolver
    var a, b, c: integer; done: boolean
        done := false
        while ¬done do
            try
                a ← read(); b ← read(); c ← read()
                x, y ← quadraticsolution(a, b, c)
                write(x); write(y)
           catch done := true
```
## Project Descriptions
<!---
The description has to elaborate on the problem, how the implementation will be tested and measured (if efficiency is the goal), how it will be documented, and what insight you hope to gain from it.
-->

<br/>

### What is `P0`: <!--(Meijing)-->
Developed by *Dr. Emil Sekerinski* and used in `COMPSCI 4TB3` course, the `P0` language is influenced by Pascal, a language designed for ease of compilation. The main syntactic elements of `P0` are _statements_, _declarations_, _types_, and _expressions_. `P0` takes the inputs of the procedures, compiles the inputs, and then generates WebAssebmbly code.

In this project, we mainly focus on extending the current `P0` to handle the exceptions in the input procedures. We will define several common exceptions(as shown below) as well as the customized exception as `keywords` so that `P0` can recognize and compile them correctly; we will also allow the `try-catch` block and `throw` clause so that `P0` can generate proper WebAssembly exceptions.

<!---
generates Indentation is used for bracketing and result parameters are named. The following example illustrates variable and procedure declarations, value and result parameters, loops, and I/O in `P0`:

```Pascal
procedure quot(x, y: integer) → (q: integer)
    var r: integer
      q := 0; r := x
      while r ≥ y do // q × y + r = x ∧ r ≥ y
        r := r - y; q := q + 1

program arithmetic
    var x, y, q, r: integer
      x ← read(); y ← read()
      q ← quot(x, y)
      write(q); writeln()
```
Procedures can also be called recursively:

```Pascal
procedure fact(n: integer) → (f: integer)
    if n = 0 then f := 1
    else
        f ← fact(n - 1); f := f × n

program factorial
    var y, z: integer
        y ← read(); z ← fact(y); write(z)
```
Above is a brief introduction of `P0` quoted from *Ch5 - The Construction of a Parser By Dr. Sekerinski* The detailed documentation of `P0` is posted as Jupyter notebooks, which are accessible to all the students who are currently taking COMPSCI 4TB3 in McMaster University.
-->

<br/>

### Exceptions stuctures will be handled in the project: <!--(Meijing)-->
- **try-catch** block:

There could be multiple `catch` blocks to capture different kinds of exceptions.
```
    try
        statements
    catch exception
        statements
    catch exception
        statements
    ...
```

- **throw** clause:

An optional `msg` could be added to the exception to give an explanation.
```
    throw exception('msg')
```

- Exceptions:
    - pre-defined Exception types:
        - **ZeroDivisionError**: Division by 0
        - **IndexError**: Indexing exceeding the range
        - **TypeError**: Operator is applied to an operand of inappropriate type
        - **NameError**: Variable name is not defined
        - **SyntaxError**: Syntax of the expression is not correct
        - ...
    - Customized Exception type:
        - **CustomizedException**: Exception thrown by the users


*Note: more types of exceptions will be updated along the process of implementing the project*

### Sepcification of Exception handling  <!--(Fanping)-->
We can now using Hoare's logic to show the specification.

Without exception handling, a `P0` statement `C` with triple `{P} C {Q}`, where `P` stands for `pre-condition`; `Q` stands for `post-condition`, indicates that if `P` holds before the excution of `C`, then `Q` holds after the excution too.

Now the quadruple `{P} C {Q, E}` indicates that, if `C` compiles and executes without error, then `Q` holds; otherwise `E` holds. For different statements `C`, we can specify `E` accordingly.
- Empty
  In this case, `E` does not exists.
- Concatenation
  If we have `{P} C_1 {Q, E_1}` and `{Q} C_2 {R, E_2}`, then `{P} C_1 {Q, E_1} C_2 {R, E_2}`.

*Note: more types of statements will be updated along the process of implementing the project*

### Implementation of Exception handling <!--(Fanping, Meijing)-->
- Explicit Exception Handling
    - *try-catch* block

      The grammar for *try-catch* block is like:
      ```
      try-catch ::= try statement { catch exception statements }
      exception ::= ZeroDivisionError | IndexError | TypeError | NameError | SyntaxError | ... | CustomizedException
      ```
    - *throw* clause

      The grammar, in this case, is like:
      ```
      throwException ::= 'throw' exception ['(' msg ')']
      ```
- Implicit Exception Handling

    For a statement `S` with expected output `o` that could potentially cause the exception `e`, to compile by `P0` or execute it, `S` will either be processed correctly and output `o`, or will output `e` to indicate that there exists an error.

    - Compiling Error
      If `S` has fatal syntax error, then the compilation will stop immediately and raise an exception.

      For example:
      ```
      a += 3
      int a = 0
      ```
      In the above code block, `a` is initialized after it is first called, which will cause an `AccessBeforeInitializationError`.

    - Run Time Error
      Sometimes an error happens when the code is executing. It is impossible to predict such error before running the code.

      For example:
      ```
      a = 34 * 5 - 170
      b = 99 / a
      ```
      Before execution, it is impossible to access the value of `a`, all we know about `a` is that: `a` is some numeric value of another expression.
      Therefore, when `99 / a` is excuted, a `ZeroDivisionError` will pop up.

    In general, `P0` tags all expressions (ie. `a/b`) with potential exceptions, and check every possible steps that may cause exceptions. After compilation, such debugging code will be embedded silently into the compiled program as well.


*Note: more details of the implementation of exception handling will be updated along the process of implementing the project*


<br/>

### Testing Method <!--(Kevin)-->
Test cases will be unit tests for the function we added to `P0`. The format will most likely similar to the test cases provided in `P0` for testing other 'built-in' functions. For testing the efficiency, built-in `time` function can be used, or more specifically, the difference between timestamps before and after the code execution is also a way to determine the efficiency.

<br/>

### Documentation <!--(Kevin)-->
The specification documentation, or the guides for the project, will be available in the project Wiki page. All the details such as function specifications, installation guide and usage will be given step-by-step to minimize the confusion of the project principles and usage. Besides, a presentation slides will be available after the project is presented at the `4TB3` course, which will help to understand the project in a straightforward manner.

<br/>

### Purpose / Outcome / Changes from the current P0 <!--(Kevin)-->
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
| 19-Mar-22 |                                |
| 26-Mar-22 |                                |
|  2-Apr-22 |                                |
|  9-Apr-22 |                                |
