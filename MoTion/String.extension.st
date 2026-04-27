Extension { #name : 'String' }

{ #category : '*MoTion' }
String >> asMatcher [

	^ MatcherLiteralString of: self
]

{ #category : '*MoTion' }
String >> asMooseObjectPath [

	| symbol |
	symbol := self asSymbol.
	symbol = #_ ifTrue: [ ^ MTDirectMooseChildrenPath new ].
	symbol = #'_*' ifTrue: [ ^ MTRecursiveMooseChildrenPath new ].
	^ self asObjectPath
]

{ #category : '*MoTion' }
String >> asObjectPath [

	| symbol |
	symbol := self asSymbol.
	(symbol includes: $>) ifTrue: [ 
		^ MTComposedPath of:
			  ((symbol splitOn: '>') collect: [ :each | each asObjectPath ]) ].
	symbol = #_ ifTrue: [ ^ MTDirectChildrenPath new ].
	symbol = #'_*' ifTrue: [ ^ MTRecursiveChildrenPath new ].
	(symbol endsWith: '*') ifTrue: [ ^ MTRecursivePath of: (symbol withoutSuffix: '*' ) ] .
	symbol = #@ ifTrue: [ ^MTIdentityPath new ].
	
	^ MTDirectPath of: symbol
]

{ #category : '*MoTion' }
String >> isValidRegex [
	
	"Returns true if self is a valide regex and false if not"

    ^[ self asRegex. true ] 
        on: Error 
        do: [ false ]
]

{ #category : '*MoTion' }
String >> orMatches: aMatcher [

	^ OrMatcher between: self asMatcher and: aMatcher asMatcher
]
