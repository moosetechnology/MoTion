Class {
	#name : 'MTDirectPathTests',
	#superclass : 'MotionPathTests',
	#category : 'MoTion-Tests-paths',
	#package : 'MoTion-Tests',
	#tag : 'paths'
}

{ #category : 'tests' }
MTDirectPathTests >> testDirectPathCreation [

	| path |
	path := #name asObjectPath.

	self assert: (path resolveFrom: path) equals: { #name }
]

{ #category : 'tests' }
MTDirectPathTests >> testDirectPathMessage [

	"This test checks if the navigation of path that is an accessor is supported"

	| o path |
	path := MTDirectPath of: #class.
	o := Object new.
	
	self assert: (path resolveFrom: o) equals: { Object }.
]

{ #category : 'tests' }
MTDirectPathTests >> testDirectPathSlot [

	"This test checks if the navigation of a simple slot"

	| path |
	path := MTDirectPath of: #name.

	self assert: (path resolveFrom: path) equals: { #name }
]
