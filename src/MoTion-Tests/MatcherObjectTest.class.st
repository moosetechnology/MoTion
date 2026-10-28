Class {
	#name : 'MatcherObjectTest',
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

{ #category : 'running' }
MatcherObjectTest >> setUp [

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

{ #category : 'tests' }
MatcherObjectTest >> testDirectChildrenPathMatcherCreation [

	| matcher |
	matcher := MTTestObjectA % { (#_ <=> MTTestObjectC % {  }) }.
	self assert: (matcher match: a) isMatch.

	matcher := MTTestObjectA
	           % { (#'_>a' <=> MTTestObjectA % { (#lint <=> 15) }) }.
	self assert: (matcher match: a) isMatch.

	matcher := MTTestObjectA
	           % { (#'_>_' <=> MTTestObjectA % { (#lint <=> 15) }) }.
	self assert: (matcher match: a) isMatch.

	matcher := MTTestObjectA % { 
		           (#_ <=> MTTestObjectB % {  }).
		           (#_ <=> MTTestObjectC % {  }) }.
	self assert: (matcher match: a) isMatch.

	matcher := MTTestObjectA % { 
		           (#_ <=> MTTestObjectB % {  }).
		           (#_ <=> MTTestObjectC % {  }).
		           (#_ <=> 15) }.
	self assert: (matcher match: a) isMatch.


	"These test should not match"
	matcher := MTTestObjectA % { (#_ <=> MTTestObjectA % {  }) }.
	self deny: (matcher match: a) isMatch.

	matcher := MTTestObjectA % { 
		           (#_ <=> MTTestObjectB % {  }).
		           (#_ <=> MTTestObjectA % {  }) }.
	self deny: (matcher match: a) isMatch
]

{ #category : 'tests' }
MatcherObjectTest >> testDirectPathLiterals [

	| matcher |
	matcher := MatcherObject type: MTTestObjectA withProperties: {  }.

	self assert: (matcher match: a) isMatch.

	matcher := MatcherObject
		           type: MTTestObjectA
		           withProperties:
		           { (#lint <=> (MatcherLiteralNumber of: 15)) }.

	self assert: (matcher match: a) isMatch.

	matcher := MatcherObject type: MTTestObjectA withProperties: { 
			           (#lint <=> (MatcherLiteralNumber of: 15)).
			           (#lstring <=> (MatcherLiteralString of: 'foo')) }.

	self assert: (matcher match: a) isMatch.


	"These test should not match"
	matcher := MatcherObject type: MTTestObjectA withProperties: { 
			           (#lint <=> (MatcherLiteralNumber of: 15)).
			           (#lstring <=> (MatcherLiteralString of: 'foobar')) }.

	self deny: (matcher match: a) isMatch.

	matcher := MatcherObject
		           type: MTTestObjectA
		           withProperties:
		           { (#lint <=> (MatcherLiteralNumber of: 16)) }.

	self deny: (matcher match: a) isMatch.

	matcher := MatcherObject
		           type: MTTestObjectA
		           withProperties:
		           { (#lint <=> (MatcherLiteralNumber of: 16)) }.

	self deny: (matcher match: b) isMatch
]

{ #category : 'tests' }
MatcherObjectTest >> testDirectPathMatcherCreation [

	| matcher |
	matcher := MTTestObjectA % {  }.
	self assert: (matcher match: a) isMatch.

	matcher := MTTestObjectA % { (#lint <=> 15) }.
	self assert: (matcher match: a) isMatch.

	matcher := MTTestObjectA % { 
		           (#lint <=> 15).
		           (#lstring <=> 'foo') }.
	self assert: (matcher match: a) isMatch.


	"These test should not match"
	matcher := MTTestObjectA % { 
		           (#lint <=> 15).
		           (#lstring <=> 'foobar') }.
	self deny: (matcher match: a) isMatch.

	matcher := MTTestObjectA % { (#lint <=> 16) }.
	self deny: (matcher match: a) isMatch.

	matcher := MTTestObjectA % { (#lint <=> 16) }.
	self deny: (matcher match: b) isMatch
]

{ #category : 'tests' }
MatcherObjectTest >> testObjectMatches [

	| matcher |
	matcher := MTTestObjectA % {
		            #'b>c' objectMatches: MTTestObjectC % {  } 
					}.
	self assert: (matcher match: a) isMatch.
	
	matcher := MTTestObjectA % {
		            #'b>c' objectMatches: MTTestObjectC % { 
							#a objectMatches: MTTestObjectA % { }
						} 
					}.
	self assert: (matcher match: a) isMatch 
	

]

{ #category : 'tests' }
MatcherObjectTest >> testPolymorphicSpaceShip [

	| pattern aa|
		
	aa := MTTestObjectA new.
	aa lstring: 'Hello World !'. 
	
	c llist: OrderedCollection new.
	c llist add: 1.
	c llist add: aa.	
		
	pattern := MTTestObjectA % {
		#b <=> MTTestObjectB % { 
			#c <=> MTTestObjectC % { 
				#'llist' <=> {1. #'*l1'}
			}.
		}.
	}.
	
	self assert: (pattern match: a) isMatch.
	
	pattern := MTTestObjectA % {
		#b <=> MTTestObjectB % { 
			#c <=> MTTestObjectC % { 
				#'llist' <=> 1
			}.
		}.
	}.
	
	self assert: (pattern match: a) isMatch.
	
	pattern := MTTestObjectA % {
		#b <=> MTTestObjectB % { 
			#c <=> MTTestObjectC % { 
				#'llist' <=> MTTestObjectA % {
					#lstring <=> 'Hello World !'.
				}.
			}.
		}.
	}.
	
	self assert: (pattern match: a) isMatch.

	
]

{ #category : 'tests' }
MatcherObjectTest >> testRecursiveChildrenPathMatcherCreation [

	| matcher |
	matcher := MTTestObjectA % { (#'_*' <=> MTTestObjectC % {  }) }.
	self assert: (matcher match: a) isMatch.
	
	matcher := MTTestObjectA % { (#'_*' <=> MTTestObjectA % {  }) }.
	self assert: (matcher match: a) isMatch.
	
	matcher := MTTestObjectA
	           % { (#'_*>a' <=> MTTestObjectA % { (#lint <=> 15) }) }.
	self assert: (matcher match: a) isMatch.

	"matcher := MTTestObjectA
	           % { (#'_*>_*' <=> MTTestObjectA % { (#lint <=> 15) }) }.
	self assert: (matcher match: a) isMatch."
	
	
	matcher := MTTestObjectA % { 
		           (#'_*' <=> MTTestObjectB % {  }).
		           (#'_*' <=> MTTestObjectA % { (#lint <=> 15) }) }.
	self assert: (matcher match: a) isMatch.


	"These test should not match"
	matcher := MTTestObjectA
	           % { (#'_*' <=> MTTestObjectA % { (#lint <=> 43) }) }.
	self deny: (matcher match: a) isMatch.
	
	

	matcher := MTTestObjectA % { 
		           (#'_*' <=> MTTestObjectB % {  }).
		           (#'_*' <=> MTTestObjectA % { (#lint <=> 16) }) }.
	self deny: (matcher match: a) isMatch

]

{ #category : 'tests' }
MatcherObjectTest >> testSimpleComposedPathMatcherCreation [

	| matcher |
	matcher := MTTestObjectA % { (#'b>c' <=> MTTestObjectC % {  }) }.
	self assert: (matcher match: a) isMatch.

	matcher := MTTestObjectA % { 
		           (#'c>a>b' <=> MTTestObjectB % {  }).
		           (#'b>c>lint' <=> 15) }.
	self assert: (matcher match: a) isMatch.


	"These test should not match"
	matcher := MTTestObjectA % { (#'b>c' <=> MTTestObjectA % {  }) }.
	self deny: (matcher match: a) isMatch.

	matcher := MTTestObjectA % { 
		           (#'c>a>b' <=> MTTestObjectB % {  }).
		           (#'b>c>lint' <=> 16) }.
	self deny: (matcher match: a) isMatch
]

{ #category : 'tests' }
MatcherObjectTest >> testSimpleIsInstanceWithProperties [

	| matcher |
	matcher := MTTestObjectA isInstanceWithProperties:
		           { (#'b>c' <=> MTTestObjectC isInstanceWithProperties: {  }) }.
	self assert: (matcher match: a) isMatch 
]

{ #category : 'tests' }
MatcherObjectTest >> testSimpleIsKindOfWithProperties [

	| matcher |
	matcher := Object isKindOfWithProperties:
		           { (#'b>c' <=> MTTestObjectC isKindOfWithProperties: {  }) }.
	self assert: (matcher match: a) isMatch
]
