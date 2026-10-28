# How to use the matcher

[← Back to README](../ReadME.md) · [Syntax](syntax.md) · [Examples](examples.md) · [Refactorings](refactorings.md)

## Getting a matcher

You get a matcher by sending `asMatcher`. For example, `1 asMatcher` creates a matcher that only matches the value `1`.
Object patterns built with `% {}` or `%% {}` are already matchers.

## Running a match

A matcher has a `match:` method that tries to match its argument:

```Smalltalk
pattern := #'@foo' asMatcher.
result := pattern match: 'text'.
result isMatch.
```

This creates a matcher that matches anything (and binds it to the name `foo`), then runs it on the string `'text'`.
The last line answers `true` because the match succeeded.

## The result

`match:` answers a `MatcherResult`. It has:
- `isMatch`: a boolean telling whether the match succeeded;
- `matchingContexts`: a collection of `MatchingContext` objects.

Each `MatchingContext` has its own `isMatch` boolean and a dictionary of its bindings.

## Bindings

To get the binding of `foo` in the example above:

```Smalltalk
result matchingContexts first bindings at: 'foo'.
```

This answers the string `'text'`.

Bindings can also be created with `as:`, which binds whatever a sub-pattern matched to a name, so you find it in the result's bindings:

```Smalltalk
FASTJavaMethodInvocation % {
    #name <=> #get.
} as: #configInvocation
```

## Collecting bindings

To get only the bindings you are interested in, use `collectBindings:for:`. It takes a collection of keys and answers their matched values.
If there is no match, it answers an empty collection.

```Smalltalk
pattern := #'@foo' asMatcher.
results := pattern collectBindings: { #foo } for: 'text'.
```

`results` is a collection of dictionaries (here only one) holding the binding for `#foo`.

- It is a **collection** because there can be several matches (for example with a disjunction, or a `*` path that reaches several objects).
- It holds **dictionaries** because you can ask for several bindings in the first argument.

## More

More examples can be found in the `MoTion-Tests` package.
