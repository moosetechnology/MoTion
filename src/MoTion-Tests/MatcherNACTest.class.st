Class {
	#name : 'MatcherNACTest',
	#superclass : 'MatcherTests',
	#instVars : [
		'a'
	],
	#category : 'MoTion-Tests-matchers',
	#package : 'MoTion-Tests',
	#tag : 'matchers'
}

{ #category : 'running' }
MatcherNACTest >> setUp [ 

	super setUp.
	
	a := MTTestObjectA new.	  
	a lint: 1. 
	a lstring: 'foo'.
	a lst: { 1. 2. 3. } asOrderedCollection 
	
	 
]

{ #category : 'tests' }
MatcherNACTest >> testNACCreation [

	| not1 |
	not1 := 1 asMatcher not.

	self assert: (not1 match: 'r') isMatch.
	self assert: (not1 match: 4) isMatch.
	self deny: (not1 match: 1) isMatch
]

{ #category : 'tests' }
MatcherNACTest >> testNACCreationOnObjectMatcher [

	| matcher a |
	matcher := MTTestObjectA % { (#lint <~=> Number %% {  }) }.

	a := MTTestObjectA new.
	a lint: 'r'.

	self assert: (matcher match: a) isMatch.

	a lint: 5.
	self deny: (matcher match: a) isMatch
]

{ #category : 'tests' }
MatcherNACTest >> testNACList [
 
	|pattern pattern2 patternNAC|
	
	pattern := OrderedCollection % { #contents <=> {1. 2. 3.} }.
	pattern2 := OrderedCollection % { #contents <=> {2. 3.} }.
	patternNAC := OrderedCollection % { #contents <~=> {2. 3.} }.

	self assert: (pattern match: a lst ) isMatch.
	self assert: (pattern2 match: a lst ) isMatch not.
	self assert: (patternNAC match: a lst) isMatch.
]

{ #category : 'tests' }
MatcherNACTest >> testNACLiteral [
 
	|pattern patternNAC|
	
	pattern := SmallInteger % { #value <=> 1}.
	patternNAC := SmallInteger % { #value <~=> 2}.

	self assert: (pattern match: a lint ) isMatch.
	self assert: (patternNAC match: a lint) isMatch.
]

{ #category : 'tests' }
MatcherNACTest >> testNACMessageObjectDoesNotMatch [

	| matcher a |
	matcher := MTTestObjectA % { (#lint objectDoesNotMatch: Number %% {  }) }.

	a := MTTestObjectA new.
	a lint: 'r'.

	self assert: (matcher match: a) isMatch.

	a lint: 5.
	self deny: (matcher match: a) isMatch
]

{ #category : 'tests' }
MatcherNACTest >> testNACOnDeepPattern [

	| matcher x y |
	
	matcher := MTTestObjectA % { 
					#lint <~=> MTTestObjectB %% { 
							#lint <=> 5 
					   } 
				  }.

	x := MTTestObjectA new.
	y := MTTestObjectB new.
	x lint: y.
	y lint: 10.

	self assert: (matcher match: x) isMatch.

	y lint: 5.
	self deny: (matcher match: x) isMatch
]

{ #category : 'tests' }
MatcherNACTest >> testNACOnType [

	| notANumber |
	notANumber := (Number %% {  }) not.

	self assert: (notANumber match: 'r') isMatch.
	self assert: (notANumber match: #a) isMatch.
	self deny: (notANumber match: 34) isMatch.
	self deny: (notANumber match: 3.42) isMatch
]

{ #category : 'tests' }
MatcherNACTest >> testNegationCombinedWithOtherConditions [
	"the negation is one more condition (AND), and the bindings outside it still work"

	| matcher aa |
	matcher := MTTestObjectA % {
		#lint <~=> (MTTestObjectB %% { #lint <=> 5 }).
		#lint <=> (MTTestObjectB %% { #lint <=> #'@value' }) }.
	aa := MTTestObjectA new lint: (MTTestObjectB new lint: 10); yourself.
	self assert: ((matcher match: aa) bindingsFor: #value) asArray equals: #(10)

]

{ #category : 'tests' }
MatcherNACTest >> testNegationOnCollectionMeansNoElement [
	"lint holds a collection: <~=> means that no element matches"

	| hasFive matcher |
	hasFive := MTTestObjectB %% { #lint <=> 5 }.
	matcher := MTTestObjectA % { #lint <~=> hasFive }.
	self deny: (matcher match: (MTTestObjectA new lint: {  MTTestObjectB new lint: 5; yourself }; yourself)) isMatch.
	self assert: (matcher match: (MTTestObjectA new lint: { MTTestObjectB new lint: 10; yourself }; yourself)) isMatch.
	self assert: (matcher match: (MTTestObjectA new lint: #(); yourself)) isMatch
]

{ #category : 'tests' }
MatcherNACTest >> testNegationOnObjectPattern [
	"lint holds one object: <~=> is the opposite of <=>"

	| hasFive matcher |
	hasFive := MTTestObjectB %% { #lint <=> 5 }.
	matcher := MTTestObjectA % { #lint <~=> hasFive }.
	self deny: (matcher match: (MTTestObjectA new lint: (MTTestObjectB new lint: 5); yourself)) isMatch.
	self assert: (matcher match: (MTTestObjectA new lint: (MTTestObjectB new lint: 10); yourself)) isMatch
]

{ #category : 'tests' }
MatcherNACTest >> testNegationThroughPathMeansNoElement [
	"the same through a path ending on a value"

	| matcher |
	matcher := MTTestObjectA % { #'lint>lint' <~=> 5 }.
	self deny: (matcher match: (MTTestObjectA new lint: { MTTestObjectB new lint: 5; yourself.}; yourself)) isMatch.
	self assert: (matcher match: (MTTestObjectA new lint: { MTTestObjectB new lint: 10; yourself }; yourself)) isMatch
]
