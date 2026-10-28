Extension { #name : 'BlockClosure' }

{ #category : '*MoTion' }
BlockClosure >> asMatcher [

	^ MatcherBlock of: self
]

{ #category : '*MoTion' }
BlockClosure >> compileToMatcher [

	^ (self compiledBlock ast statements at: 1) acceptVisitor: PharoBlockMatcherCompiler new
]

{ #category : '*MoTion' }
BlockClosure >> onCollection [
	^ MatcherConditional onList: self
]

{ #category : '*MoTion' }
BlockClosure >> onEach [
	^ MatcherConditional of: self
]

{ #category : '*MoTion' }
BlockClosure >> orMatches: aMatcher [

	^ OrMatcher between: self asMatcher and: aMatcher asMatcher
]
