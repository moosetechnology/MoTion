Class {
	#name : 'MatcherBlockTest',
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

{ #category : 'tests' }
MatcherBlockTest >> testBlockConditionalOnCollection [

	| matcher i1 |
	matcher := MTTestObjectA
	           %
	           { #lint <=> [ :collection| collection includes: 4] onCollection }.

	i1 := MTTestObjectA new.
	i1 lint: #(1 2 3 4 5 6 7).

	self assert: (matcher match: i1) isMatch.

	i1 lint: #(1 2 3 5 6 7).
	self deny: (matcher match: i1) isMatch
]

{ #category : 'tests' }
MatcherBlockTest >> testBlockConditionalOnEach [

	| matcher  i1 i2 |
	matcher := MTTestObjectA
	           %
	           { #lint <=> [ :each | each lint = 10] onEach }.

	i1 := MTTestObjectA new.
	i2 := MTTestObjectB new.
	i1 lint: i2.
	i2 lint: 10.

	self assert: (matcher match: i1) isMatch.

	i2 lint: 5.
	self deny: (matcher match: i1) isMatch
]

{ #category : 'tests' }
MatcherBlockTest >> testBlockCreation [

	| matcher |
	b := [ :myVal |  myVal + 1 ].
	matcher := MatcherBlock of: b.	 
	self assert: matcher block  equals: b. 
]
