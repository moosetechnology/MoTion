"
MoTion is a new object pattern matching language in Pharo. A pattern matching language works on a finite set of objects that we will call a model. 
Examples of models are: the Pharo AST of a method, the DOM of an XML document, the objects loaded from a JSON file,... MoTion can deal with Pharo objects independently of the model containing the data. 
MoTion combines both features for graph pattern matching and object matching listed previously, and by doing so, it enables expressing patterns declaratively and applying matches to complex object structures.

Comments will be set in each class to know how to define MoTion patterns using its specific syntax.
But meanwhile you can have a look at this [paper](https://www.sciencedirect.com/science/article/pii/S2590118424000339) which explains all about MoTion.
For quick look and info you can also have a look at the readme file of the [repository](https://github.com/moosetechnology/MoTion).

Below is an example of a MoTion pattern:
```
FamixJavaModel % {
	#'allTypes >entities' <=> FamixJavaInterface % {
		#'superInheritances >superclass >name' <=> 'Remote' .
		#'isStub' <~=> true .
	} as: 'foundInterface'.
}
```



"
Class {
	#name : 'Matcher',
	#superclass : 'Object',
	#category : 'MoTion-matcher',
	#package : 'MoTion',
	#tag : 'matcher'
}

{ #category : 'initialization' }
Matcher >> as: aSymbol [

	^ MatcherSave of: self withAlias: aSymbol
]

{ #category : 'converting' }
Matcher >> asMatcher [

	"creates instance of Matcher"

	^ self
]

{ #category : 'accessing' }
Matcher >> collectBinding: aString for: anObject [ 
	
	^ (self match: anObject) bindingsFor: aString
]

{ #category : 'accessing' }
Matcher >> collectBindings: bindings for: anObject [

	^ ((self match: anObject) matchingContexts collect: [ :context | 
		   context bindings filterKeys: bindings ]) removeDuplicates
]

{ #category : 'matching' }
Matcher >> debugMe [
	^ MatcherDebug of: self
]

{ #category : 'inspecting' }
Matcher >> inspectUsing: anInstance [

	^ MatcherInspector inspect: self using: anInstance
]

{ #category : 'inspecting' }
Matcher >> inspectionDescription [

	^ self printString
]

{ #category : 'matching' }
Matcher >> isBlockMatcher [

	^ false
]

{ #category : 'converting' }
Matcher >> isCollectionMatcher [ 
	^ false
]

{ #category : 'converting' }
Matcher >> isListWildcard [
	^ false
]

{ #category : 'matching' }
Matcher >> isMooseMatcher [

	^ false
]

{ #category : 'converting' }
Matcher >> isWildcard [
	^ false
]

{ #category : 'matching' }
Matcher >> match: aNewValue [

	"It is used to match aNewValue, but it is returning a list of emptyContext as there is no context defined here. The most important thing is to generalise the return of all match and match:withContext: of all the matchers in our code to return a list of MatchingContexts."
	
	| aNewContext matcherResult |
	aNewContext := MatchingContext new.
	matcherResult := MatcherResult new.

	^ matcherResult addAllIfMatch:
		  (self match: aNewValue withContext: aNewContext)
]

{ #category : 'matching' }
Matcher >> match: aNewValue withContext: aMatchingContext [
	
	self shouldBeImplemented 
	
]

{ #category : 'initialization' }
Matcher >> not [

	^ MatcherNAC of: self
]

{ #category : 'initialization' }
Matcher >> orMatches: aMatcher [

	^ OrMatcher between: self and: aMatcher asMatcher
]
