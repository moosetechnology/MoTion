"
This is a String literal matcher.
Also note that you can express reguar expression inside this and match it also; For example:
```
ClassA % { 
  #property <=> 'get\s+.*'.
}
```
"
Class {
	#name : 'MatcherLiteralString',
	#superclass : 'MatcherLiteral',
	#category : 'MoTion-matcher',
	#package : 'MoTion',
	#tag : 'matcher'
}

{ #category : 'matching' }
MatcherLiteralString >> match: aNewValue withContext: aContext [
	"a String matcher can either fully match a String, can be found inside another String or can be available in a list of Strings. So the first condition is used to match only one String fully or if exists in a long string, while the second one is checking if the String exists in a collection of given Strings. If a match is found, aContext isMatch is returned as True. "

	aNewValue isString
		ifTrue: [
			self value isValidRegex
				ifTrue: [ ^ self regexMatch: aNewValue withContext: aContext ]
				ifFalse: [ self matchOnlyString: aNewValue withContext: aContext ] ]
		ifFalse: [
			aNewValue isCollection & aNewValue isNotNil
				ifTrue: [
				self matchCollectionOfStrings: aNewValue withContext: aContext ]
				ifFalse: [ aContext isMatch: false ] ].

	^ { aContext }
]

{ #category : 'matching' }
MatcherLiteralString >> matchCollectionOfStrings: aCollectionOfLiterals withContext: aContext [

	aCollectionOfLiterals do: [ :each | 
		each isString ifTrue: [ "ifFalse: [ here we have to check if it is symbol like #name .... for the customStringMatcher]"
			self matchOnlyString: each withContext: aContext.
			aContext isMatch ifTrue: [ ^ self ] ] ]
]

{ #category : 'matching' }
MatcherLiteralString >> matchOnlyString: aString withContext: aContext [
	"so here we are matching either fully or at least the string exist in the chain. "

	| sizeFound |
	sizeFound := aString asString findString: value.

	aContext isMatch:
		(value = aString or: [ (aString asString findString: value) > 0 ])
]

{ #category : 'matching' }
MatcherLiteralString >> regexMatch: aNewValue withContext: aContext [

	| matches contexts|
	"match with regex"
	matches := value asRegex matchesIn: aNewValue.

	"If no matches are found, return the original context marked as false"
	matches
		ifEmpty: [ 
				aContext isMatch: false. 
				^ {aContext}  
		]
		ifNotEmpty: [ 
			"if matches found, update the context state"
			aContext isMatch: true.
			contexts := OrderedCollection new. 
			matches do: [ :eachMatch | 
					| newContext | 
					newContext := aContext copy. 
					newContext bindings at: #matchedWithRegEx put: eachMatch.
					contexts add: newContext.	
				].
			].
		
		^ contexts
]
