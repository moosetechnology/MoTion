Class {
	#name : 'MatcherTests',
	#superclass : 'TestCase',
	#instVars : [
		'parser'
	],
	#category : 'MoTion-Tests-matchers',
	#package : 'MoTion-Tests',
	#tag : 'matchers'
}

{ #category : 'tests' }
MatcherTests >> testHigherOrEqualThanMoTionDirect [

    | pattern a |
    a := MTTestObjectA new.
    a lint: 100.
    pattern := MTTestObjectA % { (#lint higherOrEqualTo: 100) }.
    self assert: (pattern match: a) isMatch.
    
    a lint: 50.
    self deny: (pattern match: a) isMatch.
]

{ #category : 'tests' }
MatcherTests >> testHigherThanWithMoTion [
    | pattern a matcher |
    a := MTTestObjectA new.
    a lint: 150.
    matcher := MatcherHigherThan new.
    matcher value: 100.
    pattern := MTTestObjectA % {
        #lint <=> matcher         "on fait comme ça car HigherThan ne marche pas sur Object, on a pu definir MatcherHigherThan inside btw"
    }.
    self assert: (pattern match: a) isMatch.
    
    a lint: 50.
    self deny: (pattern match: a) isMatch.
]

{ #category : 'tests' }
MatcherTests >> testHigherThanWithMoTionDirect [
    | pattern a |
    a := MTTestObjectA new.
    a lint: 150.
    pattern := MTTestObjectA % {
        (#lint higherThan: 100)
    }.
    self assert: (pattern match: a) isMatch.
    
    a lint: 50.
    self deny: (pattern match: a) isMatch.
]

{ #category : 'tests' }
MatcherTests >> testLessThanWithMoTionDirect [
    | pattern a |
    a := MTTestObjectA new.
    a lint: 50.
    pattern := MTTestObjectA % { (#lint lessThan: 100) }.
    self assert: (pattern match: a) isMatch.
    
    a lint: 150.
    self deny: (pattern match: a) isMatch.
]

{ #category : 'tests' }
MatcherTests >> testLessrOrEqualThanMoTionDirect [

	| pattern a |
	a := MTTestObjectA new.
	a lint: 100.
	pattern := MTTestObjectA % { (#lint lessOrEqualTo: 100) }.
	self assert: (pattern match: a) isMatch.

	a lint: 150.
	self deny: (pattern match: a) isMatch
]

{ #category : 'tests' }
MatcherTests >> testMatcherBoolean [

	| matcher |
	matcher := true asMatcher.

	self assert: (matcher match: true) isMatch.
	self deny: (matcher match: false) isMatch
]

{ #category : 'tests' }
MatcherTests >> testMatcherHigherOrEqualTo [
    | myMatcher |
    myMatcher := MatcherHigherOrEqualTo new.
    myMatcher value: 100.
    self assert: (myMatcher match: 100) isMatch.
    self assert: (myMatcher match: 150) isMatch.
    self deny: (myMatcher match: 50) isMatch.

]

{ #category : 'tests' }
MatcherTests >> testMatcherHigherThan [
    | myMatcher |
    myMatcher := MatcherHigherThan new.
    myMatcher value: 100.
    self assert: (myMatcher match: 150) isMatch.
    self deny: (myMatcher match: 50) isMatch.
]

{ #category : 'tests' }
MatcherTests >> testMatcherLessThan [
    | myMatcher |
    myMatcher := MatcherLessThan new.
    myMatcher value: 100.
    self assert: (myMatcher match: 50) isMatch.
    self deny: (myMatcher match: 150) isMatch.
]

{ #category : 'tests' }
MatcherTests >> testMatcherLessThanOrEqualTo [
    | myMatcher |
    myMatcher := MatcherLessThanOrEqualTo new.
    myMatcher value: 100.
    self assert: (myMatcher match: 100) isMatch.
    self assert: (myMatcher match: 50) isMatch.
    self deny: (myMatcher match: 150) isMatch.
]

{ #category : 'tests' }
MatcherTests >> testMatcherNil [
	
	| matcher |
	matcher := nil asMatcher.
	 
	self assert: (matcher match: nil) isMatch.
	self deny: (matcher match: 42) isMatch 
]

{ #category : 'tests' }
MatcherTests >> testMatcherNumber [
	| myMatcher |
	myMatcher := MatcherLiteralNumber  new.
	myMatcher value: 100.
	 
	self assert: (myMatcher match: 100) isMatch.
	self deny: (myMatcher match: 900) isMatch 
]

{ #category : 'tests' }
MatcherTests >> testMatcherNumberCollection [

	| myMatcher |
	myMatcher := MatcherLiteralNumber matching: 100.

	self assert: (myMatcher match: { 100. 200. 300 }) isMatch.
	self deny: (myMatcher match: 900) isMatch
]

{ #category : 'tests' }
MatcherTests >> testMatcherStringCollection [
	
	| myMatcher |
	myMatcher := MatcherLiteralString of: 'Hello'.
	 
	self assert: (myMatcher match: {'Hello World'. 'We are trying to'. 'test a collection' }) isMatch.
	self assert: (myMatcher match: {'Hello'. 'Here we are using only hello'. 'test a collection' }) isMatch.
	self deny: (myMatcher match: 'Hi Mr. hello') isMatch 
]

{ #category : 'tests' }
MatcherTests >> testMatcherStringFull [
	
	| myMatcher |
	myMatcher := MatcherLiteralString new.
	myMatcher value: 'Hello'.
	 
	self assert: (myMatcher match: 'Hello') isMatch.
	self deny: (myMatcher match: 'Hi') isMatch 
]

{ #category : 'tests' }
MatcherTests >> testMatcherStringPartial [
	
	| myMatcher |
	myMatcher := MatcherLiteralString new.
	myMatcher value: 'Hello.*'.
	 
	self assert: (myMatcher match: 'Hello World') isMatch.
	self deny: (myMatcher match: 'Hi Mr.') isMatch 
]

{ #category : 'tests' }
MatcherTests >> testMatcherSymbolCollection [
	
	| myMatcher |
	myMatcher := MatcherLiteralSymbol of: #Hello.
	 
	self assert: (myMatcher match: {#'Hello World'. #'We are trying to'. #'test a collection' . #Symbols }) isMatch.
	self assert: (myMatcher match: {#'Hello World'. #'We are trying to'. #'test a collection' . #'of many Hello' . #Symbols }) isMatch.
	self deny: (myMatcher match: 'Hi Mr. hello') isMatch 
]

{ #category : 'tests' }
MatcherTests >> testMatcherSymbolFull [
	
	| myMatcher |
	myMatcher := MatcherLiteralSymbol new.
	myMatcher value: #'a b'.
	 
	self assert: (myMatcher match: #'a b') isMatch.
	self deny: (myMatcher match: #'c d') isMatch 
]

{ #category : 'tests' }
MatcherTests >> testMatcherSymbolPartial [
	
	| myMatcher |
	myMatcher := MatcherLiteralSymbol new.
	myMatcher value: #Hi.
	 
	self assert: (myMatcher match: #'Hi Mr.') isMatch.
	self deny: (myMatcher match: 'Bonjour Mr.') isMatch 
]
