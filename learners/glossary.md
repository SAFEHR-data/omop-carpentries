---
title: 'Reference'
---

# Introduction to R and RStudio
## What is R?

R is a powerful programming language and environment specifically designed for statistical computing and data analysis. Originally created by statisticians for statisticians, R has grown into one of the most popular tools for data science, used across academia, healthcare, finance, and industry.

## Why Use R?
• Free and Open Source: R is completely free to download and use
• Comprehensive Statistical Tools: Built-in functions for virtually any statistical analysis
• Excellent for Data Visualization: Create publication-quality graphs and plots
• Reproducible Research: Your analysis is documented in code, making it easy to share and repeat
• Active Community: Thousands of packages extending R's capabilities
• Healthcare & Research Focus: Widely used in clinical research, epidemiology, and bioinformatics

## What is RStudio?

RStudio is an Integrated Development Environment (IDE) for R. Think of it this way:
• R is the engine (the programming language that does the work)
• RStudio is the dashboard (the interface that makes R easier to use)

While you can use R on its own, RStudio provides a much more user-friendly and productive environment.

## The RStudio Interface

When you open RStudio, you'll see four main panes:

Source/Editor Pane (Top Left)
• Where you write and save your R scripts
• Allows you to edit and run multiple lines of code
• Your analysis workflow lives here

Console Pane (Bottom Left)
• Where R actually executes commands
• You can type commands directly here for quick tests
• Shows output and error messages

Environment/History Pane (Top Right)
• Environment: Shows all objects, datasets, and variables currently loaded
• History: Keeps track of commands you've run

Files/Plots/Packages/Help Pane (Bottom Right)
• Files: Browse your project files
• Plots: View graphs and visualizations
• Packages: Manage installed R packages
• Help: Access documentation

## Your First Steps in R

### Basic R as a Calculator
```r
# Addition
5 + 3

# Multiplication
10 * 6

# Division
100 / 4
```

### Creating Variables
```r
# Store a value
patientage <- 45

# Store text
patientname <- "John Doe"

# Store multiple values
bloodpressure <- c(120, 135, 118, 142, 130)
```

### Getting Help
```r
# Get help on a function
?mean

# Search for help
??regression
```

## Key Concepts to Remember
### Packages
R's functionality is extended through packages - collections of functions, data, and documentation. Think of them as apps you install:

```r
# Install a package (do this once)
install.packages("ggplot2")

# Load a package (do this each session)
library(ggplot2)
```

### Scripts vs. Console
• Console: For quick tests and one-off commands
• Scripts: For saving your analysis workflow that you can run again later

### Comments
Use # to add comments to your code:
```r
# This is a comment - R will ignore it
patientcount <- 150  # You can also comment after code
```
## Other tips
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

## Tips for Getting Started
Use Projects: RStudio Projects keep your work organized
Save Your Scripts: Your code is your documentation
Don't Fear Errors: Error messages help you learn - read them carefully
Use Tab Completion: Start typing and press Tab for suggestions
Check Your Working Directory: Know where R is looking for files with getwd()

## Common Beginner Mistakes
• Case Sensitivity: R distinguishes between Data and data
• Missing Commas: Function arguments need commas: mean(x, na.rm = TRUE)
• Unmatched Parentheses: Every ( needs a closing )
• Wrong Assignment Operator: Use <- for assignment, not = (though = works in some contexts)

## Next Steps

Once you're comfortable with the basics:
Learn to import and explore data
Master data manipulation with packages like dplyr
Create visualizations with ggplot2
Perform statistical analyses relevant to your field
Generate reports with R Markdown

## Resources
• Built-in Help: Type ?function_name` in the console
• Cheat Sheets: RStudio provides excellent cheat sheets (Help → Cheat Sheets)
• Stack Overflow: Great for troubleshooting specific problems
• R for Data Science: Free online book at r4ds.had.co.nz

Remember: Everyone starts as a beginner. The best way to learn R is by doing - start with simple tasks and gradually build your skills. The R community is welcoming and helpful, so don't hesitate to ask questions!


## Project management with RStudio

- To create a new project, go to File -> New Project
- Install the `packrat` package to create self-contained projects
- `install.packages` to install packages from CRAN
- `library` to load a package into R
- `packrat::status` to check whether all packages referenced in your
  scripts have been installed.
