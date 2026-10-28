Class {
	#name : 'MTComposedPathTests',
	#superclass : 'MotionPathTests',
	#instVars : [
		'a',
		'b',
		'c'
	],
	#category : 'MoTion-Tests-paths',
	#package : 'MoTion-Tests',
	#tag : 'paths'
}

{ #category : 'running' }
MTComposedPathTests >> setUp [

	super setUp.

	a := MTTestObjectA new.
	b := MTTestObjectB new.
	c := MTTestObjectC new.


	a b: b.
	a c: c.
	b c: c.
	c a: a.
	
]

{ #category : 'tests' }
MTComposedPathTests >> testComplexPathOfDifferentPaths [

	| path |
	path := MTComposedPath of: { 
			        MTDirectChildrenPath new.
			        (MTDirectPath of: #c).
			        (MTDirectPath of: #a) }.

	self assert: (path resolveFrom: a) equals: { a }.

	"Path is b>_>a>_>_>_ should yield all the elements at the end"
	path := MTComposedPath of: { 
			        (MTDirectPath of: #b).
			        MTDirectChildrenPath new.
			        (MTDirectPath of: #a).
			        MTDirectChildrenPath new.
			        MTDirectChildrenPath new.
			        MTDirectChildrenPath new }.

	self assertCollection: (path resolveFrom: a) hasSameElements: { 
			a.
			b.
			c }.

	"Path is _>a> should yield only a"
	path := MTComposedPath of: { 
			        MTDirectChildrenPath new.
			        (MTDirectPath of: #a) }.
	self assertCollection: (path resolveFrom: a) equals: { a }
]

{ #category : 'tests' }
MTComposedPathTests >> testComplexPathOfDifferentPathsCreation [

	| path |
	path := #'_>c>a' asObjectPath.

	self assert: (path resolveFrom: a) equals: { a }.

	"Path is b>_>a>_>_>_ should yield all the elements at the end"
	path := #'b>_>a>_>_>_' asObjectPath.

	self assertCollection: (path resolveFrom: a) hasSameElements: { 
			a.
			b.
			c }.

	"Path is _>a> should yield only a"
	path := #'_>a' asObjectPath.

	self assertCollection: (path resolveFrom: a) equals: { a }
]

{ #category : 'tests' }
MTComposedPathTests >> testComplexPathOfDirectPath [

	| path |
	path := MTComposedPath of: { 
			        (MTDirectPath of: #b).
			        (MTDirectPath of: #c).
			        (MTDirectPath of: #a) }.

	self assert: (path resolveFrom: a) equals: { a }
]

{ #category : 'tests' }
MTComposedPathTests >> testComplexPathOfDirectPathCreation [

	| path |
	path := #'b>c>a' asObjectPath.

	self assert: (path resolveFrom: a) equals: { a }
]

{ #category : 'tests' }
MTComposedPathTests >> testPolymorphicComposedPath [

	| path aa|
		
	c llist: OrderedCollection new.
	aa := MTTestObjectA new.
	aa lstring: 'Hello World !'. 
		
	c lint: 1.
	path := #'b>c>lint' asObjectPath.
	self assert: (path resolveFrom: a) equals: {1}.
		
	c llist add: 1.
	c llist add: aa.
	path := #'b>c>llist' asObjectPath.
	self assert: (path resolveFrom: a) equals: {1. aa }.
	
	path := #'b>c>llist>lstring' asObjectPath.
	self assert: (path resolveFrom: a) equals: {'Hello World !'}.
]
