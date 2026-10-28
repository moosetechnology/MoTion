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
    (symbol endsWith: '*') ifTrue: [
        ^ MTRecursivePath of: (symbol withoutSuffix: '*') ].
    (symbol includesSubstring: '*') ifTrue: [
        | parts |
        parts := symbol splitOn: $*.
        ^ MTRecursiveLimitedPath of: parts first depth: parts last asInteger ].
    symbol = #@ ifTrue: [ ^ MTIdentityPath new ].
    ^ MTDirectPath of: symbol
]

{ #category : '*MoTion' }
String >> higherOrEqualTo: aValue [

	^ self -> (MatcherHigherOrEqualTo matching: aValue)
]

{ #category : '*MoTion' }
String >> higherThan: aValue [

	^ self -> (MatcherHigherThan matching: aValue)
]

{ #category : '*MoTion' }
String >> isValidRegex [
	
	"Returns true if self is a valide regex and false if not"

    ^[ self asRegex. true ] 
        on: Error 
        do: [ false ]
]

{ #category : '*MoTion' }
String >> lessOrEqualTo: aValue [

	^ self -> (MatcherLessThanOrEqualTo matching: aValue)
]

{ #category : '*MoTion' }
String >> lessThan: aValue [

	^ self -> (MatcherLessThan matching: aValue)
]

{ #category : '*MoTion' }
String >> orMatches: aMatcher [

	^ OrMatcher between: self asMatcher and: aMatcher asMatcher
]
