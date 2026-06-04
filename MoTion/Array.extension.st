Extension { #name : 'Array' }

{ #category : '*MoTion' }
Array >> asMatcher [
	^ MatcherCollection of: (self collect: #asMatcher).
]

{ #category : '*MoTion' }
Array >> match: anObject [

	^ self asMatcher match: anObject
]

{ #category : '*MoTion' }
Array >> orMatches: aMatcher [

	^ OrMatcher between: self asMatcher and: aMatcher asMatcher
]

{ #category : '*MoTion' }
Array >> orderIgnored [

	^  MatcherSet  of: (self collect: #asMatcher).
]
