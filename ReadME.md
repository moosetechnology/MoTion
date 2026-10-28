## Description

MoTion is a new object pattern matcher in Pharo. A pattern matcher works on a finite set of objects that we will call a model. Examples of models are: the Pharo AST of a method, the DOM of an XML document, the objects loaded from a JSON file, ...
MoTion can deal with Pharo objects independently of the model containing the data.
MoTion combines both features for graph pattern matching and object matching, and by that it enables expressing patterns declaratively and applying matches over complex object structures.
With its refactoring rules, MoTion can also transform the code it matches.

[![Latest Moose](https://github.com/moosetechnology/MoTion/actions/workflows/tests.yml/badge.svg)](https://github.com/moosetechnology/MoTion/actions/workflows/tests.yml)

## Installation
To install MoTion, go to the Playground (`Ctrl+OW`) in your Pharo image and execute the following Metacello script (select it and press Do-it button or `Ctrl+D`):

```Smalltalk
Metacello new
    baseline: 'MoTion';
    repository: 'github://moosetechnology/MoTion:main/src';
    load.
```

To also load the refactorings on FAST models, use `load: 'MoTionFAST'` instead of `load` (see [Refactorings with MoTion](docs/refactorings.md#installation)).

## A first look

```Smalltalk
pattern := FamixJavaModel % {
    #'allTypes>entities' <=> FamixJavaInterface % {
        #'superInheritances>superclass>name' <=> 'Remote'.
        #'isStub' <~=> true.
    } as: 'foundInterface'.
}.

pattern match: aFamixJavaModel.
```

This pattern finds, in a Java model, the interfaces that inherit from `Remote` and are not stubs, and binds each one to `foundInterface`.

## Documentation

| Page | What you'll find |
|---|---|
| [Syntax](docs/syntax.md) | All the operators: object patterns `% {}` / `%% {}`, `<=>`, negation `<~=>`, `@x` variables, wildcards, paths `>`, recursion `*`, lists, sets, `orMatches:`, number comparisons |
| [How to use the matcher](docs/using-the-matcher.md) | `asMatcher`, `match:`, results, bindings with `as:` and `collectBindings:for:` |
| [Some cool examples](docs/examples.md) | Patterns on Famix Java, FAST Java, Pharo packages and XML |
| [Refactorings with MoTion](docs/refactorings.md) | Renaming, replacing and removing code with `MoTionRule` |

## Finally

Don't hesitate to ask. More examples can be found in the tests packages.
Also, if you are not familiar with MoTion or are using it for the first time, no worries: you can find skills for MoTion that you can use with any AI agent here: https://github.com/alesshosry/MoTionSkills.
Also, don't hesitate to have a look at Iguala, which is the same matcher implemented in Python: https://github.com/aranega/iguala
Finally, well, just enjoy it :)
