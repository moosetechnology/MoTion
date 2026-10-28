"
Paths are used in properties; You have different types of paths expressed in subclasses.
The purpose of their creation is to express a way to access properties and sub properties.
"
Class {
	#name : 'MotionPath',
	#superclass : 'Object',
	#instVars : [
		'name'
	],
	#category : 'MoTion-paths',
	#package : 'MoTion',
	#tag : 'paths'
}

{ #category : 'resolving' }
MotionPath >> asObjectPath [ 
	^ self
]

{ #category : 'resolving' }
MotionPath >> isMooseObjectPath [
	^ false
]

{ #category : 'resolving' }
MotionPath >> name: aName [
	name := aName
]

{ #category : 'resolving' }
MotionPath >> resolveCollectionFrom: anObject [
	^ self resolveFrom: anObject
]

{ #category : 'resolving' }
MotionPath >> resolveFrom: anObject [
	self shouldBeImplemented 
]

{ #category : 'as yet unclassified' }
MotionPath >> resolveOwnerFrom: anObject [
	^ { anObject }
]
