"
A matcherWildCard is like a jocker, whenever a MatcherWildCard is created, for the first matching process the isMatch is true, and the context is filled with the matcher value and alias. Then when a new match is applied, it will start matching the values with the existing context. So the idea is to match two Objects together to see if they exactly match and have the same properties. 
It is also used to indicate an unknown property, when one only cares for its value:
For example:

```
ClassA % {
	#_ <=> aValue.
}
```
"
Class {
	#name : 'MatcherWildcard',
	#superclass : 'Matcher',
	#instVars : [
		'alias'
	],
	#category : 'MoTion-matcher',
	#package : 'MoTion',
	#tag : 'matcher'
}

{ #category : 'instance creation' }
MatcherWildcard class >> of: aSymbol [
	^ self new alias: aSymbol ;
		yourself 
	
]

{ #category : 'accessors' }
MatcherWildcard >> alias [
	^ alias
]

{ #category : 'accessor' }
MatcherWildcard >> alias: aString [ 
	 alias := aString .
]

{ #category : 'accessors' }
MatcherWildcard >> isAnonymous [
	^ alias asSymbol = #_ 
]

{ #category : 'accessors' }
MatcherWildcard >> isWildcard [ 
	^ true
]

{ #category : 'private-running' }
MatcherWildcard >> match: aNewValue withContext: aMatchingContext [

	| aResult idx owner |
	self isAnonymous ifTrue: [ 
		aMatchingContext isMatch: true.
		^ { aMatchingContext } ].

	aResult := aMatchingContext bindings at: alias ifAbsentPut: [ 
		           aMatchingContext isMatch: true.
		           aNewValue ].
	aMatchingContext isMatch: aResult = aNewValue.
"checking if the current node is literal or not. if yes add new binding and fill it with the parent node of the current match. this is useful for the refactoring."
	((aNewValue respondsTo: #startPos) not and: [ aMatchingContext currentPropertyValues notNil ]) ifTrue: [
		idx := aMatchingContext currentPropertyValues indexOf: aNewValue ifAbsent: [ 0 ].
		"ok for values, normaly their must be one value. but could be mutiple owners specially when we have for example a path like _ which can match anything" 
		idx > 0 ifTrue: [
			owner := aMatchingContext currentPropertyOwners at: idx ifAbsent: [ nil ].
			owner ifNotNil: [
				aMatchingContext bindings
					at: (alias , 'Node') asSymbol
					ifAbsentPut: [ owner ] ] ] ].

	^ { aMatchingContext }
]
