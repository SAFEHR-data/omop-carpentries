---
title: 'Reference'
---

## Reference

## Introduction to R and RStudio

- Use the escape key to cancel incomplete commands or running code
  (Ctrl+C) if you're using R from the shell.
- Basic arithmetic operations follow standard order of precedence:
  - Brackets: `(`, `)`
  - Exponents: `^` or `**`
  - Divide: `/`
  - Multiply: `*`
  - Add: `+`
  - Subtract: `-`
- Scientific notation is available, e.g: `2e-3`
- Anything to the right of a `#` is a comment, R will ignore this!
- Functions are denoted by `function_name()`. Expressions inside the
  brackets are evaluated before being passed to the function, and
  functions can be nested.
- Mathematical functions: `exp`, `sin`, `log`, `log10`, `log2` etc.
- Comparison operators: `<`, `<=`, `>`, `>=`, `==`, `!=`
- Use `all.equal` to compare numbers!
- `<-` is the assignment operator. Anything to the right is evaluate, then
  stored in a variable named to the left.
- `ls` lists all variables and functions you've created
- `rm` can be used to remove them
- When assigning values to function arguments, you *must* use `=`.

## Project management with RStudio

- To create a new project, go to File -> New Project
- Install the `packrat` package to create self-contained projects
- `install.packages` to install packages from CRAN
- `library` to load a package into R
- `packrat::status` to check whether all packages referenced in your
  scripts have been installed.

## Glossary

[argument]{#argument}
:   A value given to a function or program when it runs.
The term is often used interchangeably (and inconsistently) with [parameter](#parameter).

[assign]{#assign}
:   To give a value a name by associating a variable with it.

[body]{#body}
:   (of a function): the statements that are executed when a function runs.

[comment]{#comment}
:   A remark in a program that is intended to help human readers understand what is going on,
but is ignored by the computer.
Comments in Python, R, and the Unix shell start with a `#` character and run to the end of the line;
comments in SQL start with `--`,
and other languages have other conventions.

[comma-separated values]{#comma-separated-values}
:   (CSV) A common textual representation for tables
in which the values in each row are separated by commas.

[delimiter]{#delimiter}
:   A character or characters used to separate individual values,
such as the commas between columns in a [CSV](#comma-separated-values) file.

[documentation]{#documentation}
:   Human-language text written to explain what software does,
how it works, or how to use it.

[floating-point number]{#floating-point-number}
:   A number containing a fractional part and an exponent.
See also: [integer](#integer).

[for loop]{#for-loop}
:   A loop that is executed once for each value in some kind of set, list, or range.
See also: [while loop](#while-loop).

[function call]{#function-call} 
: A use of a function in another piece of code.

[index]{#index}
:   A subscript that specifies the location of a single value in a collection,
such as a single pixel in an image.

[integer]{#integer}
:   A whole number, such as -12343. See also: [floating-point number](#floating-point-number).

[library]{#library}
:   In R, the directory(ies) where [packages](#package) are stored.

[package]{#package}
:   A collection of R functions, data and compiled code in a well-defined format. Packages are stored in a [library](#library) and loaded using the library() function.

[parameter]{#parameter}
:   A variable named in the function's declaration that is used to hold a value passed into the call.
The term is often used interchangeably (and inconsistently) with [argument](#argument).

[return statement]{#return-statement}
:   A statement that causes a function to stop executing and return a value to its caller immediately.

[sequence]{#sequence}
:   A collection of information that is presented in a specific order.

[shape]{#shape}
:   An array's dimensions, represented as a vector.
For example, a 5�3 array's shape is `(5,3)`.

[string]{#string}
:   Short for "character string",
a [sequence](#sequence) of zero or more characters.

[syntax error]{#syntax-error}
:   A programming error that occurs when statements are in an order or contain characters
not expected by the programming language.

[type]{#type}
:   The classification of something in a program (for example, the contents of a variable)
as a kind of number (e.g. [floating-point number](#floating-point-number), [integer](#integer)), [string](#string),
or something else. In R the command typeof() is used to query a variables type.

[while loop]{#while-loop}
:   A loop that keeps executing as long as some condition is true.
See also: [for loop](#for-loop).


