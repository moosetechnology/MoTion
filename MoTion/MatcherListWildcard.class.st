Class {
	#name : 'MatcherListWildcard',
	#superclass : 'MatcherWildcard',
	#category : 'MoTion-matcher',
	#package : 'MoTion',
	#tag : 'matcher'
}

{ #category : 'testing' }
MatcherListWildcard >> isListWildcard [ 
	^ true
]

{ #category : 'testing' }
MatcherListWildcard >> match: aNewValue withContext: aMatchingContext [

	| aResult |
	self isAnonymous ifTrue: [ 
		aMatchingContext isMatch: true.
		^ { aMatchingContext } ].

	aResult := aMatchingContext bindings at: alias ifAbsentPut: [ 
		           aMatchingContext isMatch: true.
		           aNewValue ].
	aMatchingContext isMatch: aResult = aNewValue.
	
	^ { aMatchingContext }
]
