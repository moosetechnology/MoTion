Extension { #name : 'Boolean' }

{ #category : '*MoTion' }
Boolean >> asMatcher [

	^ MatcherLiteralBoolean of: self
]
