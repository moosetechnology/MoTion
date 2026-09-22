"
""matchingContext handles the contexts of each match; the matched contexts are all filled as Dictionaries in bindings""
"
Class {
	#name : 'MatchingContext',
	#superclass : 'Object',
	#instVars : [
		'bindings',
		'isMatch',
		'currentPropertyOwner'
	],
	#category : 'MoTion-results',
	#package : 'MoTion',
	#tag : 'results'
}

{ #category : 'accessing' }
MatchingContext >> atBindingKey: aKey put: aValue [

	self bindings at: aKey asSymbol put: aValue

	"Since the MatchingContext can be used in different places (same function can have input and output the Matching Context), we leave the isMatch to be filled in the Matcher code, more specifically in the match and match:withCOntext methods."
]

{ #category : 'accessing' }
MatchingContext >> bindings [

	^ bindings
]

{ #category : 'accessing' }
MatchingContext >> copy [

	| instance |
	instance := self class new.
	instance bindings addAll: self bindings.
	instance isMatch: self isMatch.
	^ instance
]

{ #category : 'accessing' }
MatchingContext >> currentPropertyOwner [

	^ currentPropertyOwner
]

{ #category : 'accessing' }
MatchingContext >> currentPropertyOwner: anObject [

	currentPropertyOwner := anObject
]

{ #category : 'initialization' }
MatchingContext >> initialize [ 
	super initialize.
	bindings := Dictionary new.
	isMatch := false.
]

{ #category : 'accessing' }
MatchingContext >> isMatch [

	^ isMatch
]

{ #category : 'accessing' }
MatchingContext >> isMatch: aBoolean [

	isMatch := aBoolean
]
