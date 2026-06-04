## Description

MoTion is a new object pattern matcher in Pharo. A pattern matcher works on a finit set of objects that we will call a model. Examples of  models are: the Pharo AST of a method, the DOM of an XML document, the objects loaded from a JSON file,. . .
MoTion can deal with Pharo objects independently of the model containing the data. 
MoTion combines both features for graph pattern matching and object matching, and by that it enables expressing patterns declaratively and applying matches over complex object structures.

[![Latest Moose](https://github.com/moosetechnology/MoTion/actions/workflows/tests.yml/badge.svg)](https://github.com/moosetechnology/MoTion/actions/workflows/tests.yml)

## Installation
To install MoTion, go to the Playground (`Ctrl+OW`) in your Pharo image and execute the following Metacello script (select it and press Do-it button or `Ctrl+D`):

```Smalltalk
Metacello new
    baseline: 'MoTion';
    repository: 'github://moosetechnology/MoTion:main';
    load.
```

## Syntax

Multiple operators are used to help developers creating MoTion patterns.
1. Literals are declared the way they are in Pharo like ’A sample text here’ asMatcher and 1 asMatcher. 
Literal patterns match exactly their literal value. This is useful for specifying the value that a property of an object must have.
2. The “<=>” operator is a sort of generic matcher. It tries to match its left hand side (lhs) with the pattern on its right hand side (rhs).
As noted before, it is a polymorphic operator depending on the lhs. If the lhs is an object, it tries to match this object with the rhs. If the lhs is a
collection, it tries to match any element of the collection with the rhs.
3. To define an object pattern, one specifies its type using the class name followed by the “\% {}” operator like in: ClassA \% {} . The class expected comes before “\% {}” and property values can be specified between the curly braces (see below).
4. A similar operator: “\%\% {}” is used to match a class or any of its subclasses.
5. These two operators can express sub-patterns on the properties of the matched object. They are specified between the curly braces. Object properties are instance variable accessors. The curly braces act as a conjunction of sub-patterns specifying the value a property should match. It can be seen as a Logical matcher.
```Smalltalk
ClassA % {
#’property1’ <=> aValue1.
#’property2’ <=> aValue2.
}
```
This pattern matches an object of class ClassA, with a property property1 having the value aValue1 and property2 having the value aValue2.
The sub-patterns could also be more complex (see bellow, Structural pattern).
This mechanism contributes to the seamless addition of various properties, in a declarative way.   
6. The “\% {}” operator, combined with the “<=>” operator, also allows to express Structural pattern where a first object is matched, then a second object in one of the properties of the first is matched and we express a sub-pattern on this second object:
```Smalltalk
ClassA % {
#’property1’ <=> aValue1.
#’property2’ <=> ClassB %% {
        #’property3’ <=> aValue3.
    }
}
```
This pattern matches an instance of ClassA with aValue1 in its property1, and an instance of ClassB in its property2. This second object
must have aValue3 in its property3. 

7. Negation in pattern matching is handle with the “<∼=>” operator. It specifies that the lhs should not match the rhs pattern.
8. Non-Linear pattern is obtain using the “@” operator followed by a name (for example: @x). This allows to store a matched object in the “variable” to reuse it somewhere else in the pattern. 
9. Wildcard (“_”) can be used to indicate a property whose name is not known, when one only cares for its value:
```Smalltalk
ClassA % {
    #_ <=> aValue.
}
```
This pattern matches an instance of ClassA with an unnamed property matching the value aValue. 

10. The “>” operators implements Path traversal by allowing to “chain” multiple properties in a pattern. Such paths help reducing complex patterns expression, by accessing a chain of objects and their properties:
```Smalltalk
ClassA % {
#’property1>property2’ <=> aValue.
}
```
This pattern first match an instance of ClassA, then it takes the object in its property1 and the value in property2 of this second object. This value should match aValue. This notation allows to express in a very concise way a path in a graph of objects. Note that this operator is also polymorphic. Similarly to “<=>”, if one of the objects in the path is a collection, the operator will look for an element of this collection that allows to continue the search, that is to say that has a property matching the remaining part of the pattern.

11. MoTion allows to perform Recursive traversal through a “*” operator combined with the Path traversal operator “>”. In a chain of objects, one may know the initial property and the final one, but not know how long the chain of objects is.
```Smalltalk
ClassA % {
#’property1>repeatedProp*’ <=> aValue.
}
```
This pattern will match first an instance of ClassA, then the object in its property property1 then it will match a chain of objects all having a property repeatedProp and one of them containing the value aValue. The match ends on this last
object.

12. The “*” operator may also be combined with a wildcard (“_”).
```Smalltalk
ClassA % {
#’property1>_*>propN’ <=> aValue.
}
```
This pattern will match first an instance of ClassA, then the object in its property property1 then it will match a chain of objects with unknown properties ending with an object having a property propN with value aValue.

13. It is possible to match Complex lists using the “{}” list operator and declaring how the list should look like. Note that this is not the same operator as “\% {}” (see above). This operator allows to express that given elements in a list should match specific patterns. 
{\#’@x’. \#’@x’} This pattern matches a list containing exactly two elements that are the same (use of a named variable).
14. The repetition operator (“*”) may also be used in a list to indicate an unspecified number of elements.
{#’@x’. #’*_’. #’@x’} This pattern, matches a list with first and last elements equals and of unspecified length (obviously at least 2).
To express that one element is part of a collection, MoTion offers a shortcut. To check if the value 5 is part of a collection (contained in the property someProperty of an instance of ClassA) one can use the pattern:
```Smalltalk
ClassA % {
    #someProperty <=> {#’*s1’. 5. #’*s2’}
}
```
But the same can be expressed with a shortcut:
```Smalltalk
ClassA % {
    #someProperty<=> 5
}
```
Note that this could also match an instance of ClassA with a property someProperty that matches exactly the value 5 (with no collection).
15. Set matcher is also included. It does the same thing as list matcher but without taking into consideration the order of the elements. For example:
```Smalltalk
"A pattern can be expressed this way using set matcher:"
pattern := { 2. 1. 'a'} orderIgnored.
result := pattern match: #( 1 2 'a').
```
In the above example, result will return a match, because even if order is not respected, the same elements can be found in the array that is matched with the defined pattern.
The below example also works for a set matcher inside an object matcher:
```Smalltalk
pattern := MTTestObjectA % {
			    #lst <=> { 1. 2. #’*others’} orderIgnored 
		    }.
a1 := MTTestObjectA new.
a1 lst add: 2.
a1 lst add: 1. 
a1 lst add: 3.
a1 lst add: 4.
	
result := pattern match: a1.
```
Result will return a match.

16. Finally there is another operator for Logical matcher:  orMatches:. It allows to express a disjunction of two patterns (one or the other match). (Remember that “\% {}” implements a conjunction of patterns within the curly braces.)
```Smalltalk
ClassA % {
#someProperty <=> (5 orMatches: 6)
}
```
This pattern matches an instance of ClassA with a property someProperty matching the value 5 or the value 6.

## How to use the matcher

1. One gets a “matcher” by calling the asMatcher
method. 
“1 asMatcher” creates a matcher that only matches the value “1”.
2. A matcher as a match: method that allows it to try to match the argument.
```Smalltalk
pattern := #’@foo’ asMatcher.
results := pattern match: ’text’ .
result isMatch.
```
This creates a matcher than matches anything (and associates it with the “foo” symbol) and runs it on the string ’text’. The last line will answer true as the match was successful.
The result of match: is a MatchingResult. 
As we just saw, it includes a boolean property isMatch indicating whether the match was successful or not. It also has a property, and matchingContexts which is a collection of MatchingContext objects. Each of these contexts
includes again a boolean field isMatch and a dictionary of its bindings.
To get the binding of foo in the the small example
above, one would do:
```Smalltalk
results matchingContexts first bindings
at: ’foo’.
```
This will return the string ’text’. Bindings can also be created with the as: method. 
It is used to bind the result of a pattern that will be kept in the result’s bindings. 
Finally to simplify getting the result of the bindings one is mostly interested in, there is a method collectBindings: that accepts a collection of (interesting) keys as parameter, and returns their values matched by a pattern.
In case there is no match, the return is an empty collection.
```Smalltalk
pattern := #’@foo’ asMatcher.
results := pattern collectBindings: {#foo } for: ’text’ .
```
This puts in results a collection of dictionaries (here there is only one) with the binding for the #foo symbol.
The result is a collection because there could be several matchings (for example with a disjunction operator). The collection holds dictionaries because we could ask for several bindings in the first parameter of the method.

## Some cool examples

1. Finding superInheritances for 'Remote' Inteface in Java model: 

```Smalltalk
pattern := FamixJavaModel % {
 #'allTypes>entities' <=>
  FamixJavaInterface % {
   #'superInheritances>superclass>name'
    <=> 'Remote' .
   #'isStub' <~=> true.
 } as: 'foundInterface'.
}.

pattern match: aFamixJavaModel.

```

2. Looking for methods where get.config(akey) is invoked

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

3. Decomposing the same pattern for reusage of small patterns

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

4. MoTion matching Pharo package

```Smalltalk
pattern := RPackage % {
		#name <=> #MoTion.
		#'definedClasses>methodDict' <=> CompiledMethod % { 
			#'ast>allChildren' <=>  RBMessageNode % { 
                #'selector>value' <=> #ifTrue:ifFalse:
			} as: #Node
		} as: #Method.
	} as: #Package.

pattern collectBindings: {#Node. #Method. #Package.} for: (#MoTion asPackage).
```

5. MoTion matching XML node list

```Smalltalk
pattern := XMLNodeList % {  
			#'_' <=> XMLElement % {
				#'name' <=> #'div' .  
			} as: 'XMLElement'. 
		}.

pattern match: anXMLNodeList.
```

## Finally

Don't hesitate to ask. More examples can be found in tests package. 
Also if you are not familiar with MoTion, using it for the first time, no worries; here are some pages with examples: https://github.com/alesshosry/MoTionPatternsBookForAI. You can check them OR provide the files to AI agents so they can create the patterns for you ;) 
Also, don't hesitate to have a look at Iguala which is the same matcher implemented in Python:  https://github.com/aranega/iguala
Finally, well, just enjoy it :)  