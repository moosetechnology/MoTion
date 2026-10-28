# Some cool examples

[← Back to README](../ReadME.md) · [Syntax](syntax.md) · [Using the matcher](using-the-matcher.md) · [Refactorings](refactorings.md)

## 1. Interfaces that inherit from `Remote` in a Java model

```Smalltalk
pattern := FamixJavaModel % {
    #'allTypes>entities' <=> FamixJavaInterface % {
        #'superInheritances>superclass>name' <=> 'Remote'.
        #'isStub' <~=> true.
    } as: 'foundInterface'.
}.

pattern match: aFamixJavaModel.
```

## 2. Methods where `config.get(aKey)` is invoked

```Smalltalk
pattern := FASTJavaMethodEntity % {
    #'children*' <=> FASTJavaMethodInvocation % {
        #'receiver>name' <=> #'config'.
        #name <=> #get.
        #'arguments>primitiveValue' <=> aKey.
    } as: #configInvocation
}.

pattern match: aFASTJavaMethodEntity.
```

## 3. The same pattern, split into reusable parts

```Smalltalk
childrenPath := #'children*'.
receiverNamePath := #'receiver>name'.
argsVal := #'arguments>primitiveValue'.

subPattern := FASTJavaMethodInvocation % {
    receiverNamePath <=> #'config'.
    #name <=> #get.
    argsVal <=> aKey.
} as: #configInvocation.

pattern := FASTJavaMethodEntity % {
    childrenPath <=> subPattern.
}.

pattern match: aFASTJavaMethodEntity.
```

## 4. Matching a Pharo package

Finds every `ifTrue:ifFalse:` sent in the methods of the MoTion package:

```Smalltalk
pattern := RPackage % {
    #name <=> #MoTion.
    #'definedClasses>methodDict' <=> CompiledMethod % {
        #'ast>allChildren' <=> RBMessageNode % {
            #'selector>value' <=> #ifTrue:ifFalse:
        } as: #Node
    } as: #Method.
} as: #Package.

pattern collectBindings: { #Node. #Method. #Package } for: #MoTion asPackage.
```

## 5. Matching an XML node list

```Smalltalk
pattern := XMLNodeList % {
    #'_' <=> XMLElement % {
        #'name' <=> #'div'.
    } as: 'XMLElement'.
}.

pattern match: anXMLNodeList.
```

## More

More examples can be found in the `MoTion-Tests` package, and refactoring examples in [Refactorings with MoTion](refactorings.md).
