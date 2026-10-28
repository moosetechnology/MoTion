Class {
	#name : 'MTDirectChildrenPathTests',
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

{ #category : 'tests' }
MTDirectChildrenPathTests >> setUp [

	super setUp.

	a := MTTestObjectA new.
	b := MTTestObjectB new.
	c := MTTestObjectC new.

	a b: b.
	a c: c.
	b c: c.
	c a: a
]

{ #category : 'tests' }
MTDirectChildrenPathTests >> testDirectChildrenDirectPathEquivalence [

	"Tests that the result yield by a DirectChildren and a DirectPath are the same when there is only one instance variable in the start object"

	| directChildrenPath directPath |
	directChildrenPath := MTDirectChildrenPath new.
	directPath := MTDirectPath of: #name.

	self
		assert: (directChildrenPath resolveFrom: directPath)
		equals: (directPath resolveFrom: directPath)
]

{ #category : 'tests' }
MTDirectChildrenPathTests >> testDirectChildrenDirectPathEquivalenceCreation [

	"Tests that the result yield by a DirectChildren and a DirectPath are the same when there is only one instance variable in the start object"

	| directPath |
	directPath := MTDirectPath of: #name.

	self
		assert: (#_ asObjectPath resolveFrom: directPath)
		equals: (#name asObjectPath resolveFrom: directPath)
]

{ #category : 'tests' }
MTDirectChildrenPathTests >> testDirectChildrenPathCreation [
	
	| path |
	path := #_ asObjectPath.
	
	self assertCollection: (path resolveFrom: a) hasSameElements: { b. c. }.
	self assert: (path resolveFrom: b) equals: { c. }.
	self assert: (path resolveFrom: c) equals: { a. }.
]

{ #category : 'tests' }
MTDirectChildrenPathTests >> testMultipleChildrenPath [
	
	| path |
	path := MTDirectChildrenPath new.
	
	self assertCollection: (path resolveFrom: a) hasSameElements: { b. c. }.
	self assert: (path resolveFrom: b) equals: { c. }.
	self assert: (path resolveFrom: c) equals: { a. }.
]
