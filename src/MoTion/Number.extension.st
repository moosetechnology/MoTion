Extension { #name : 'Number' }

{ #category : '*MoTion' }
Number >> asMatcher [

	^ MatcherLiteralNumber of: self
]

{ #category : '*MoTion' }
Number >> orMatches: aMatcher [

	^ OrMatcher between: self asMatcher and: aMatcher asMatcher
]
