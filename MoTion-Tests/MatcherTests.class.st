Class {
	#name : 'MatcherTests',
	#superclass : 'TestCase',
	#category : 'MoTion-Tests-matchers',
	#package : 'MoTion-Tests',
	#tag : 'matchers'
}

{ #category : 'tests' }
MatcherTests >> testMatcherBoolean [

	| matcher |
	matcher := true asMatcher.

	self assert: (matcher match: true) isMatch.
	self deny: (matcher match: false) isMatch
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
	myMatcher := MatcherLiteralNumber of: 100.
	 
	self assert: (myMatcher match: {100. 200. 300 }) isMatch.
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
MatcherTests >> testMatcherStringRegEx [

	| myMatcher |
	myMatcher := MatcherLiteralString new.
	myMatcher value: '\{\{[^}]+\}\}'.

	self assert:
		(myMatcher match: 'The {{fox}} jumped over the {{dog}}') isMatch.
	self deny: (myMatcher match: 'Hi') isMatch
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
