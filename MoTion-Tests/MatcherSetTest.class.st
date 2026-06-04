Class {
	#name : 'MatcherSetTest',
	#superclass : 'MatcherTests',
	#category : 'MoTion-Tests-matchers',
	#package : 'MoTion-Tests',
	#tag : 'matchers'
}

{ #category : 'tests' }
MatcherSetTest >> testListWildcardAndWildcard [
	
	| pattern result | 
	pattern := { #'@anItem'. #'*aList'. } orderIgnored.
	result := pattern match: #( 1 2 3 ). 
	self assert: result isMatch
]

{ #category : 'tests' }
MatcherSetTest >> testListWildcardAndWildcardAndLiteral [
	
	| pattern result | 
	pattern := { 3. #'@anItem'. #'*aList'} orderIgnored.
	result := pattern match: #( 1. 2. 3 ). 
	self assert: result isMatch
]

{ #category : 'tests' }
MatcherSetTest >> testListWildcardEmpty [

	| pattern result |
	"pattern := { #'*listEmpty' } orderIgnored.
	result := pattern match: {  }.
	self assert: result isMatch"
]

{ #category : 'tests' }
MatcherSetTest >> testListWildcardMultipleNotEmpty [
	
	| pattern result | 
	pattern := { #'*list1'. #'*list2'. } orderIgnored.
	result := pattern match: #( 1. 2. ). 
	self assert: result isMatch
]

{ #category : 'tests' }
MatcherSetTest >> testListWildcardNotEmpty [
	
	| pattern result | 
	pattern := { #'*list'. } orderIgnored.
	result := pattern match: #( 1. 2. ). 
	self assert: result isMatch
]

{ #category : 'tests' }
MatcherSetTest >> testLiterals [

	| pattern result |
	pattern := { 2. 1. 'a'} orderIgnored.
	result := pattern match: #( 1 2 'a').
	self assert: result isMatch
]

{ #category : 'tests' }
MatcherSetTest >> testLiteralsLess [
	
	| pattern result | 
	pattern := { 2.} orderIgnored.
	result := pattern match: #( 1 2 'a'). 
	self deny: result isMatch
]

{ #category : 'tests' }
MatcherSetTest >> testLiteralsNumbers [

	| pattern result |
	pattern := { 2. 1. } orderIgnored.
	result := pattern match: #( 1 2 ).
	self assert: result isMatch
]

{ #category : 'tests' }
MatcherSetTest >> testLiteralsString [

	| pattern result |
	pattern := { 'Hello'. 'World' } orderIgnored.
	result := pattern match: #( 'World' 'Hello' ).
	self assert: result isMatch
]

{ #category : 'tests' }
MatcherSetTest >> testLiteralsWithObject [

	| pattern a1 result|
	
	pattern := MTTestObjectA % {
			             #lst <=> { 1. 2. } orderIgnored 
			 		}.

	a1 := MTTestObjectA new.
	a1 lst add: 1.
	a1 lst add: 2. 
	
	result := pattern match: a1.
	self assert: result isMatch.
	
	a1 lst add: 3.
	result := pattern match: a1.
	self deny: result isMatch.
]

{ #category : 'tests' }
MatcherSetTest >> testObjectInSet [
	
	| pattern result | 
	
	pattern := { 1. 'str'.  MTTestObjectA % {} } orderIgnored .
	result := pattern match: { MTTestObjectA new. 'str'. 1.}. 
	self assert: result isMatch
]

{ #category : 'tests' }
MatcherSetTest >> testSetInObject [
	
	| pattern pattern2 result objA objB| 
	
	pattern := MTTestObjectA % { 
		#lst <=> { MTTestObjectB % {}. #'*others'} orderIgnored
	}.
	
	pattern2 := MTTestObjectA % { 
		#lst <=> { #'*others'.  MTTestObjectB % {}. } orderIgnored
	}.
	
	objB := MTTestObjectB new.
	objB lstring: 'A string added'.
	
	objA := MTTestObjectA new . 
	objA lst add: 'Hello'.
	objA lst add: 1.
	objA lst add: objB.
	
	result := pattern match: objA . 
	self assert: result isMatch.
	
	result := pattern2 match: objA . 
	self assert: result isMatch.
	 
	
	
]

{ #category : 'tests' }
MatcherSetTest >> testWildcardSingle [
	
	| pattern result | 
	pattern := { #'@anItem'.} orderIgnored.
	result := pattern match: #( 1 ). 
	self assert: result isMatch
]

{ #category : 'tests' }
MatcherSetTest >> testWildcardSingle2 [
	
	| pattern result | 
	pattern := { #'@anItem'.} orderIgnored.
	result := pattern match: #( 1. 2 ). 
	self deny: result isMatch
]

{ #category : 'tests' }
MatcherSetTest >> testWildcardsPattern [
	
	"not working yet, but should be"
	| pattern result | 
	pattern := { #'@item1'. #'@item2'.} orderIgnored.
	result := pattern match: #( 1 2 ). 
	self assert: result isMatch
]
