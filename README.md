By **Wednesday, March 9**, you have to submit to the GitLab repository a plan with (1) a description of the project, (2) all the resources to be used (textbooks, manuals, software, articles, etc.), (3) division of work, (4) weekly schedule. The project plan should have **2 - 3 pages**. Use markdown, not Word; use LaTeX only if you need the math features. All group members have to commit to the repository for the plan to receive a grade. The description has to elaborate on the problem, how the implementation will be tested and measured (if efficiency is the goal), how it will be documented, and what insight you hope to gain from it. You will receive feedback on the project plan.

## Project Proposal: Topic 1 - Extending P0 with Exceptions
#### Background
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
#### Description
The description has to elaborate on the problem, how the implementation will be tested and measured (if efficiency is the goal), how it will be documented, and what insight you hope to gain from it 

TODO

#### Resources
TODO
- [WebAssembly/exception-handling](https://github.com/WebAssembly/exception-handling/blob/master/proposals/exception-handling/Exceptions.md)

#### Division of work
TODO

#### Weekly schedule
TODO


TODO
