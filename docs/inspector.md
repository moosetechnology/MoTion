# Debugging patterns with the inspector

[← Back to README](../ReadME.md) · [Syntax](syntax.md) · [Using the matcher](using-the-matcher.md) · [Examples](examples.md) · [Refactorings](refactorings.md)

When a pattern does not match an object you expected it to match, finding the incorrect part by hand can be tricky, especially with deep patterns.
`inspectUsing:` might be of great help: it tells you **which constraint of your pattern prevents the match**.

## Usage

```Smalltalk
result := aPattern inspectUsing: anObject.
```

`inspectUsing:` answers a `MatcherInspectorResult`.

## How it works

1. The pattern is matched against the object. If it already matches, the inspection stops there.
2. Otherwise, the inspector collects every **removable constraint** of the pattern: the properties of object patterns (`#prop <=> ...`) and the elements of list patterns.
3. It tries them one by one, **deepest first**, then **left to right** for constraints at the same depth. For each one, it builds a copy of the pattern without that constraint and matches it again.
4. The first copy that matches gives the **suspicious constraint**: removing it is enough to make the pattern match.

Your pattern is never modified: every attempt is made on a copy.

## The result

| Message | What it answers |
|---|---|
| `isMatch` | whether the **original** pattern matches |
| `originalResult` | the `MatcherResult` of the original pattern |
| `foundSuspiciousConstraint` | whether a constraint was found whose removal makes the pattern match |
| `suspiciousConstraint` | that constraint (`nil` if none) |
| `suspiciousConstraintDescription` | the constraint as you wrote it, for example `#'selector>value' <=> #'@same'` |
| `successfulResult` | the `MatcherResult` of the pattern without the suspicious constraint |
| `testedConstraints` / `testedConstraintsCount` | the constraints that were candidates for removal |
| `message` | a sentence summing up the outcome |

The `message` is one of:
- `'Original matcher already matches the instance'`
- `'The matcher starts matching when this constraint is removed'`
- `'No single constraint removal restored a match'`

## Examples

### The pattern already matches

```Smalltalk
pattern := Package % {
    #'definedClasses>methodDict>ast>allChildren' <=> OCMessageNode % {
        #'selector>value' <=> #ifTrue:ifFalse:
    }
}.

result := pattern inspectUsing: #MoTion asPackage.

result isMatch.               "true"
result suspiciousConstraint.  "nil"
```

### A typo in a deep constraint

`#ifTrue:ifFals:` is misspelled, so nothing in the package matches:

```Smalltalk
pattern := Package % {
    #'definedClasses>methodDict>ast>allChildren' <=> OCMessageNode % {
        #'selector>value' <=> #ifTrue:ifFals:
    }
}.

result := pattern inspectUsing: #MoTion asPackage.

result isMatch.                    "false"
result foundSuspiciousConstraint.  "true"
result successfulResult isMatch.   "true"
```

### Two constraints that disagree

Here `#'@same'` requires the selector and the number of arguments to be the same value, which is impossible:

```Smalltalk
node := OCParser parseExpression: 'true ifTrue: [ 1 ] ifFalse: [ 2 ]'.

pattern := OCMessageNode % {
    #'selector>value' <=> #'@same'.
    #'arguments>size' <=> #'@same'
}.

result := pattern inspectUsing: node.

result suspiciousConstraintDescription.  "'#''selector>value'' <=> #''@same'''"
```

Both constraints are at the same depth, so the leftmost one is tried and reported first.

### Lists and wildcards

The inspector also looks inside list patterns, list wildcards (`#'*l1'`), and property wildcards (`#'_'`, `#'_*'`):

```Smalltalk
node := OCParser parseExpression: 'true ifTrue: [ 1 ] ifFalse: [ 2 ]'.

"Both arguments are blocks, not a block and a literal"
pattern := OCMessageNode % {
    #arguments <=> { OCBlockNode % {}. OCLiteralValueNode % {} }
}.
(pattern inspectUsing: node) foundSuspiciousConstraint.  "true"

"No direct child is the literal 99"
pattern := OCMessageNode % {
    '_' <=> OCLiteralValueNode % { #value <=> 99 }
}.
(pattern inspectUsing: node) foundSuspiciousConstraint.  "true"
```

## Limits

- Only **one** constraint is removed at a time. If two constraints are wrong, removing either one is not enough, and the inspector answers `'No single constraint removal restored a match'`.
- The class of an object pattern (`ClassA % {...}`) is not a removable constraint. If the root object has the wrong class, no removal can help.
- In an exact list pattern, removing one element also changes the expected length of the list. The inspector may then report the whole property rather than the faulty element.

## More

All the cases above are in `MatcherInspectorTests` (package `MoTion-Tests`).