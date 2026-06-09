Class {
	#name : 'CaseMatcher',
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

{ #category : 'instance creation' }
CaseMatcher class >> of: aValue [ 
	   ^ self new
		  value: aValue;
		  yourself
]

{ #category : 'running' }
CaseMatcher >> setUp [ 

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
CaseMatcher >> testCaseDoComplexObject [

	| aa pattern1 pattern2 pattern3 results |
	
	results := OrderedCollection new.
	aa := MTTestObjectA new.
	aa lstring: 'Hello World !'. 
	
	c llist: OrderedCollection new.
	c llist add: 1.
	c llist add: aa.	
		
	pattern1 := MTTestObjectA % {
		#b <=> MTTestObjectB % { 
			#c <=> MTTestObjectC % { 
				#'llist' <=> {1. #'*l1'}
			}.
		}.
	}.
		
	pattern2 := MTTestObjectA % {
		#b <=> MTTestObjectB % { 
			#c <=> MTTestObjectC % { 
				#'llist' <=> 1
			}.
		}.
	}.
	
	pattern3 := MTTestObjectA % {
		#b <=> MTTestObjectB % { 
			#c <=> MTTestObjectC % { 
				#'llist' <=> MTTestObjectA % {
					#lstring <=> 'Hello World !'.
				}.
			}.
		}.
	}.
	
	a 
		case: pattern1 do: [ :res | results add: 'Matcher 1'] ;
		case: pattern2 do: [ :res | results add: 'Matcher 2'] ;
		case: pattern2 do: [ :res | results add: 'Matcher 3'] .
		"defaultDo: [  ]."
		
	self assert: results equals: {'Matcher 1'. 'Matcher 2'. 'Matcher 3'} asOrderedCollection .
	
	
	

]

{ #category : 'tests' }
CaseMatcher >> testCaseDoExtractBindingsFromList [

	| objectToMatch p1 p2 result bindings|
	objectToMatch := #(1 2 1 2 3).
	p1 := {#'*l1'}  .
	p2 := {#'*l1'. 55}.
	
	objectToMatch 
		case: p1 do: [:res |  result := res] ;
		case: p2 do: [:res |  result := res] .
		"defaultDo: [ Transcript show: 'Default'] ."
	
	bindings := result matchingContexts collect: [ :each | each bindings ].
	
	self assert: bindings size equals: 1 .
	self assert: bindings first size equals: 1 .
	self assert: bindings first keys equals: #('l1') .
	self assert:( bindings first at: 'l1') equals: #(1 2 1 2 3).
	

]

{ #category : 'tests' }
CaseMatcher >> testCaseDoListMatching [

	| objectToMatch p1 p2 result |
	objectToMatch := #(1 2 1 2 3).
	p1 := {#'*l1'}  .
	p2 := {#'*l1'. 55}.
	
	objectToMatch 
		case: p1 do: [:res |  result := 'Matcher 1'] ;
		case: p2 do: [:res |  result := 'Matcher 2'] .
		"defaultDo: [ Transcript show: 'Default'] ."
	
	self assert: result equals: 'Matcher 1'.
	

]

{ #category : 'tests' }
CaseMatcher >> testCaseDoLiteralObject [

	
	| objectToMatch p1 p2 result |
	objectToMatch := 1.
	p1 := 1 asMatcher .
	p2 := 2 asMatcher .
	
	objectToMatch 
		case: p1 do: [:res |  result := 'Matcher 1'] ;
		case: p2 do: [:res |  result := 'Matcher 2'] .
		"defaultDo: [ Transcript show: 'Default'] ."
	
	self assert: result equals: 'Matcher 1'.
	

]
