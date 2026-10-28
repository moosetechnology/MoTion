# MoTion syntax

[← Back to README](../ReadME.md) · [Using the matcher](using-the-matcher.md) · [Examples](examples.md) · [Refactorings](refactorings.md)

Several operators help you write MoTion patterns.

- [Literals](#1-literals)
- [The `<=>` operator](#2-the--operator)
- [Object patterns: `% {}` and `%% {}`](#3-object-patterns--and-)
- [Structural patterns](#4-structural-patterns)
- [Negation: `<~=>`](#5-negation-)
- [Named variables (non-linear patterns): `@x`](#6-named-variables-non-linear-patterns-x)
- [Wildcard: `_`](#7-wildcard-_)
- [Path traversal: `>`](#8-path-traversal-)
- [Recursive traversal: `*` and `*N`](#9-recursive-traversal--and-n)
- [List patterns: `{}`](#10-list-patterns-)
- [Set patterns: `orderIgnored`](#11-set-patterns-orderignored)
- [Disjunction: `orMatches:`](#12-disjunction-ormatches)
- [Number comparisons](#13-number-comparisons)

## 1. Literals

Literals are written the way they are in Pharo, for example `'A sample text here' asMatcher` or `1 asMatcher`.
A literal pattern matches exactly its literal value. This is useful for specifying the value that a property of an object must have.

## 2. The `<=>` operator

`<=>` is a generic matcher. It tries to match its left-hand side (lhs) with the pattern on its right-hand side (rhs).

It is polymorphic, depending on the lhs:
- if the lhs is an object, it tries to match this object with the rhs;
- if the lhs is a collection, it tries to match any element of the collection with the rhs.

## 3. Object patterns: `% {}` and `%% {}`

To define an object pattern, write the expected class followed by the `% {}` operator, for example `ClassA % {}`.
Property values can be specified between the curly braces.

The similar operator `%% {}` matches a class **or any of its subclasses**.

Between the curly braces you write sub-patterns on the properties of the matched object. Properties are instance variables or accessors.
The curly braces act as a **conjunction** of sub-patterns (a logical "and"):

```Smalltalk
ClassA % {
    #'property1' <=> aValue1.
    #'property2' <=> aValue2.
}
```

This pattern matches an object of class `ClassA` whose `property1` matches `aValue1` and whose `property2` matches `aValue2`.
This lets you add properties one after another, declaratively.

## 4. Structural patterns

Combining `% {}` with `<=>` lets you express structural patterns: a first object is matched, then a second object in one of its properties is matched, with its own sub-pattern:

```Smalltalk
ClassA % {
    #'property1' <=> aValue1.
    #'property2' <=> ClassB %% {
        #'property3' <=> aValue3.
    }
}
```

This pattern matches an instance of `ClassA` with `aValue1` in its `property1`, and an instance of `ClassB` (or a subclass) in its `property2`.
That second object must have `aValue3` in its `property3`.

## 5. Negation: `<~=>`

Negation is expressed with the `<~=>` operator. It specifies that the lhs should **not** match the rhs pattern.

```Smalltalk
FamixJavaInterface % {
    #'isStub' <~=> true.
}
```

`objectDoesNotMatch:` is a keyword alias of `<~=>` (and `objectMatches:` is an alias of `<=>`).

## 6. Named variables (non-linear patterns): `@x`

The `@` prefix followed by a name (for example `#'@x'`) stores the matched object in a "variable".
Using the same name again elsewhere in the pattern requires the same value there, which makes the pattern non-linear.

```Smalltalk
{ #'@x'. #'@x' }
```

This pattern matches a list of exactly two elements that are equal.

Any sub-pattern can also be bound to a name with `as:` (see [Using the matcher](using-the-matcher.md#bindings)).

## 7. Wildcard: `_`

The wildcard `_` can be used for a property whose name is not known, when you only care about its value:

```Smalltalk
ClassA % {
    #_ <=> aValue.
}
```

This pattern matches an instance of `ClassA` with any property matching `aValue`.

## 8. Path traversal: `>`

The `>` operator chains several properties in one pattern. Paths make complex patterns shorter by walking a chain of objects and their properties:

```Smalltalk
ClassA % {
    #'property1>property2' <=> aValue.
}
```

This pattern first matches an instance of `ClassA`, then takes the object in its `property1`, then the value in `property2` of that second object. This value must match `aValue`.

The operator is polymorphic too. Like `<=>`, if one of the objects along the path is a collection, MoTion looks for an element of the collection that lets the search continue, that is, an element whose property matches the rest of the pattern.

## 9. Recursive traversal: `*` and `*N`

### Unlimited recursion

Combined with `>`, the `*` operator allows recursive traversal. In a chain of objects you may know the first and last properties without knowing how long the chain is:

```Smalltalk
ClassA % {
    #'property1>repeatedProp*' <=> aValue.
}
```

This pattern matches an instance of `ClassA`, then the object in its `property1`, then a chain of objects that all have a property `repeatedProp`, one of which contains `aValue`. The match ends on that last object.

### Limited recursion

`*N` (for example `*3`) limits the depth of the recursion. This avoids searching forever, especially when properties point to each other in a loop:

```Smalltalk
ClassA % {
    #'property1>repeatedProp*3' <=> aValue.
}
```

This pattern stops at the 3rd level, whether or not a match was found.

### Recursion with a wildcard

`*` can also be combined with the wildcard `_`:

```Smalltalk
ClassA % {
    #'property1>_*>propN' <=> aValue.
}
```

This pattern matches an instance of `ClassA`, then the object in its `property1`, then a chain of objects through unknown properties, ending on an object whose `propN` matches `aValue`.

## 10. List patterns: `{}`

A plain `{}` (without `%`) is a list pattern: it describes what a list must look like, element by element.
Note that this is not the same operator as `% {}`.

```Smalltalk
{ #'@x'. #'@x' }
```

matches a list of exactly two elements that are the same.

Inside a list, `*` stands for any number of elements (a list wildcard). It can be named, like `#'*rest'`, or anonymous, `#'*_'`:

```Smalltalk
{ #'@x'. #'*_'. #'@x' }
```

matches a list of any length (at least 2) whose first and last elements are equal.

### Shortcut for "is part of the collection"

To check that the value 5 is in a collection held by `someProperty`, you can write:

```Smalltalk
ClassA % {
    #someProperty <=> { #'*s1'. 5. #'*s2' }
}
```

The same can be written with a shortcut:

```Smalltalk
ClassA % {
    #someProperty <=> 5
}
```

Note that the shortcut also matches an instance of `ClassA` whose `someProperty` is exactly `5` (no collection).

## 11. Set patterns: `orderIgnored`

A set pattern works like a list pattern but ignores the order of the elements:

```Smalltalk
pattern := { 2. 1. 'a' } orderIgnored.
result := pattern match: #( 1 2 'a' ).
```

`result` is a match: the order differs, but the same elements are found in the array.

Set patterns also work inside object patterns:

```Smalltalk
pattern := MTTestObjectA % {
    #lst <=> { 1. 2. #'*others' } orderIgnored
}.
a1 := MTTestObjectA new.
a1 lst add: 2.
a1 lst add: 1.
a1 lst add: 3.
a1 lst add: 4.

result := pattern match: a1.
```

`result` is a match.

## 12. Disjunction: `orMatches:`

`orMatches:` expresses a disjunction of two patterns (one or the other matches).
Remember that `% {}` is a conjunction of the patterns inside its curly braces.

```Smalltalk
ClassA % {
    #someProperty <=> (5 orMatches: 6)
}
```

This pattern matches an instance of `ClassA` whose `someProperty` matches 5 or 6.

## 13. Number comparisons

Thanks to a contribution by @AminRannen, properties can be compared to numbers with `higherThan:`, `higherOrEqualTo:`, `lessThan:` and `lessOrEqualTo:`:

```Smalltalk
ClassA % {
    #someProperty higherThan: 10
}
```
