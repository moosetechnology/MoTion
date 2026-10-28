Class {
	#name : 'MatcherWildcardTest',
	#superclass : 'MatcherTests',
	#instVars : [
		'a',
		'b',
		'c'
	],
	#category : 'MoTion-Tests-matchers',
	#package : 'MoTion-Tests',
	#tag : 'matchers'
}

{ #category : 'initialization' }
MatcherWildcardTest >> setUp [

	super setUp.

	a := MTTestObjectA new.
	b := MTTestObjectB new.
	c := MTTestObjectC new.

	a b: b.
	a c: c.
	b c: c.
	c a: a.
	
	a lint: 15.
	b lint: 42.
	c lint: 15.
	
	a lstring: 'foo'.
	b lstring: 'bar'.
	c lstring: 'foobar'.
]

{ #category : 'initialization' }
MatcherWildcardTest >> testWildcardCreation [

	| matcher |
	
	matcher := MatcherWildcard of: #foo.
	 
	self assert: matcher alias  equals: #foo. 
]

{ #category : 'initialization' }
MatcherWildcardTest >> testWildcardFirstMatch [

	| matcher result aContext |
	matcher := MatcherWildcard of: #foo.
	result := matcher match: 123.

	self assert: result isMatch.
	self assert: result matchingContexts size equals: 1.

	aContext := result matchingContexts first.
	self assert: (aContext bindings includesKey: #foo).
	self assert: (aContext bindings at:#foo) equals: 123.
]

{ #category : 'initialization' }
MatcherWildcardTest >> testWildcardIsAnonymous [

	| matcher |
	matcher := #'@_' asMatcher.

	self assert: matcher isAnonymous
]

{ #category : 'initialization' }
MatcherWildcardTest >> testWildcardMultipleMatch [

	| matcher aContext |
	matcher := MatcherWildcard of: #foo.

	aContext := MatchingContext new.
	matcher match: 123 withContext: aContext.
	self assert: aContext isMatch.

	matcher match: 123 withContext: aContext.
	self assert: aContext isMatch.

	matcher match: 1 withContext: aContext.
	self deny: aContext isMatch.

	self assert: (aContext bindings includesKey: #foo).
	self assert: (aContext bindings at: #foo) equals: 123
]

{ #category : 'initialization' }
MatcherWildcardTest >> testWildcardMultipleMatchCreation [

	| matcher aContext |
	matcher := #'@foo' asMatcher.

	aContext := MatchingContext new.
	matcher match: 123 withContext: aContext.
	self assert: aContext isMatch.

	matcher match: 123 withContext: aContext.
	self assert: aContext isMatch.

	matcher match: 1 withContext: aContext.
	self deny: aContext isMatch.

	self assert: (aContext bindings includesKey: #foo).
	self assert: (aContext bindings at: #foo) equals: 123
]
