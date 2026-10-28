# Refactorings with MoTion

[← Back to README](../ReadME.md) · [Syntax](syntax.md) · [Using the matcher](using-the-matcher.md) · [Examples](examples.md)

Besides finding code, MoTion can **transform** it. You write a pattern that binds the parts of the code you want to change, then a `MoTionRule` rewrites those parts in the source text.

Refactorings currently work on FAST models like [FAST-Java](https://github.com/moosetechnology/FAST-Java) or other [FAST metamodels](https://github.com/orgs/Evref-BL/repositories?q=fast), because they rely on every node knowing its position in the source (`startPos` / `endPos`). They are tested on TypeScript, with [FASTTypeScript](https://github.com/moosetechnology/FASTTypescript).

## Installation

Refactorings live in the `MoTion-FAST-Transformation` package. Load them with the `MoTionFAST` group, which also loads FASTTypeScript:

```Smalltalk
Metacello new
    baseline: 'MoTion';
    repository: 'github://moosetechnology/MoTion:main/src';
    load: 'MoTionFAST'.
```

## How it works

1. **Parse** the source code to get a FAST model.
2. **Write a pattern** that matches what you want to change and binds it to names, with `as:`, `#'@x'` or `#'*rest'`.
3. **Create a `MoTionRule`** with:
   - `sourcePattern:` the pattern;
   - `model:` the FAST node to match on (a class, a method, ...). Its source text is kept by the rule;
   - `bindings:` a dictionary from binding names to the new text, **or** `removalBindings:` the names of the bindings to delete.
4. **Execute** it: `executeRefactorings` (replace) or `executeRemoval` (delete).

Both answer the **new source code as a string**. The model and the original source are not modified. Parse the new source again if you need the new model.

```Smalltalk
parser := FASTTypeScriptParser new.
model := parser parse: sourceCode.

rule := MoTionRule new.
rule sourcePattern: aPattern.
rule model: aFASTNode.
rule bindings: { #bindingName -> 'new text' } asDictionary.

newSource := rule executeRefactorings.
newModel := parser parse: newSource.
```

## Which text gets replaced

What is replaced depends on how the binding was made in the pattern:

| Binding in the pattern | What it is bound to | What gets replaced |
|---|---|---|
| `SomeNode % {...} as: #x` | a node | the whole node's source |
| `#sourceCode <=> #'@x'` | a literal (a string) | the node that owns that literal |
| `{ #'@p1'. #'@p2' }` in a list | one element (a node) | that element |
| `{ #'@p1'. #'*rest' }` in a list | several elements | everything from the first to the last element, replaced by **one** string |

Changes are applied from the end of the source to the beginning, so earlier positions stay valid while several bindings are replaced.

## Examples

The examples below use this TypeScript source, taken from `TestTSTransformationWithMoTion`:

```typescript
class Calculator {
  add(a: number, b: number, unused: string): number {
    return a + b;
  }

  multiply(a: number, b: number): number {
    const result = a * b;
    this.record(result);
    return result;
  }

  compute(x: number, y: number, z: number, w: number): number {
    return x + y + z + w;
  }
}
```

```Smalltalk
parser := FASTTypeScriptParser new.
model := parser parse: sourceCode.
calculator := (model allWithType: FASTTypeScriptClassDeclaration) first.
methodNamed := [ :name |
    (model allWithType: FASTTypeScriptMethodDefinition)
        detect: [ :m | m name sourceCode = name ] ].
add := methodNamed value: 'add'.
multiply := methodNamed value: 'multiply'.
compute := methodNamed value: 'compute'.
```

### Rename a method

Bind the method's name node with `as:` and give it its new text:

```Smalltalk
pattern := FASTTypeScriptMethodDefinition % {
    #name <=> FASTTypeScriptPropertyIdentifier % {
        #sourceCode <=> 'multiply'
    } as: #methodName
}.

rule := MoTionRule new.
rule sourcePattern: pattern.
rule model: multiply.
rule bindings: { #methodName -> 'multiplication' } asDictionary.
newSource := rule executeRefactorings.
```

The same can be done by binding the literal with `@`. MoTion then replaces the node that owns that literal:

```Smalltalk
pattern := FASTTypeScriptMethodDefinition % {
    #name <=> FASTTypeScriptPropertyIdentifier % {
        #sourceCode <=> #'@methodName'
    }
}.

rule := MoTionRule new.
rule sourcePattern: pattern.
rule model: multiply.
rule bindings: { #methodName -> 'sum' } asDictionary.
newSource := rule executeRefactorings.
```

### Rename a class and one of its methods at once

```Smalltalk
pattern := FASTTypeScriptClassDeclaration % {
    #name <=> FASTTypeScriptTypeIdentifier % {
        #sourceCode <=> 'Calculator'
    } as: #className.
    #'children*' <=> FASTTypeScriptMethodDefinition % {
        #name <=> FASTTypeScriptPropertyIdentifier % {
            #sourceCode <=> 'compute'
        } as: #methodName
    }
}.

rule := MoTionRule new.
rule sourcePattern: pattern.
rule model: calculator.
rule bindings: {
    #className -> 'AdvancedCalculator'.
    #methodName -> 'calculate' } asDictionary.
newSource := rule executeRefactorings.
```

### Replace method parameters

Each `@p` in the list pattern is one parameter:

```Smalltalk
pattern := FASTTypeScriptMethodDefinition % {
    #parameters <=> FASTTypeScriptFormalParameters % {
        #parameters <=> { #'@p1'. #'@p2'. #'@p3'. #'@p4' }
    }
}.

rule := MoTionRule new.
rule sourcePattern: pattern.
rule model: compute.
rule bindings: {
    #p1 -> 'a: number'.
    #p2 -> 'b: number'.
    #p3 -> 'c: number'.
    #p4 -> 'd: number' } asDictionary.
newSource := rule executeRefactorings.
"compute(a: number, b: number, c: number, d: number)"
```

A list wildcard `*rest` replaces all the remaining parameters with a single string:

```Smalltalk
pattern := FASTTypeScriptMethodDefinition % {
    #parameters <=> FASTTypeScriptFormalParameters % {
        #parameters <=> { #'@p1'. #'@p2'. #'*rest' }
    }
}.

rule := MoTionRule new.
rule sourcePattern: pattern.
rule model: compute.
rule bindings: {
    #p1 -> 'a: number'.
    #p2 -> 'b: number'.
    #rest -> 'c: number' } asDictionary.
newSource := rule executeRefactorings.
"compute(a: number, b: number, c: number)"
```

### Remove a method

Use `removalBindings:` and `executeRemoval` instead of `bindings:` and `executeRefactorings`:

```Smalltalk
pattern := FASTTypeScriptClassDeclaration % {
    #'children*' <=> FASTTypeScriptMethodDefinition % {
        #name <=> FASTTypeScriptPropertyIdentifier % {
            #sourceCode <=> 'multiply'
        }
    } as: #methodToDelete
}.

rule := MoTionRule new.
rule sourcePattern: pattern.
rule model: calculator.
rule removalBindings: #( #methodToDelete ).
newSource := rule executeRemoval.
```

### Remove a parameter

When the removed node is in a comma-separated list, the comma next to it is removed too:

```Smalltalk
pattern := FASTTypeScriptMethodDefinition % {
    #parameters <=> FASTTypeScriptFormalParameters % {
        #parameters <=> { #'@p1'. #'@p2'. #'@p3' }
    }
}.

rule := MoTionRule new.
rule sourcePattern: pattern.
rule model: add.
rule removalBindings: #( #p3 ).
newSource := rule executeRemoval.
"add(a: number, b: number)"
```

With `{ #'@p1'. #'*rest' }` and `removalBindings: #( #rest )`, every parameter after the first one is removed.

## Things to know

- A rule works on **source text**: it answers a new string and changes nothing in the image or on disk. Save or re-parse the result yourself.
- If the pattern matches several times, every match is rewritten with the same new text.
- Only nodes with source positions (`startPos` / `endPos`) can be rewritten, which is why refactorings currently need a FAST model.
- When `executeRemoval` gets a binding that is a plain string (from `#'@x'`), it looks for the **first** node in the model with that exact source code. Prefer `as:` on the node you want to delete.

## More

All the cases above, and more, are in `TestTSTransformationWithMoTion` (package `MoTion-FAST-Transformation-Tests`).
To write patterns and rules with an AI agent, see [MoTionSkills](https://github.com/alesshosry/MoTionSkills).
