Class {
	#name : 'MTTestObjectA',
	#superclass : 'Object',
	#instVars : [
		'b',
		'c',
		'lint',
		'lstring',
		'lfloat',
		'lst'
	],
	#category : 'MoTion-Tests-class-data-tests',
	#package : 'MoTion-Tests',
	#tag : 'class-data-tests'
}

{ #category : 'accessing' }
MTTestObjectA >> b: aB [
	b := aB
]

{ #category : 'accessing' }
MTTestObjectA >> c: aC [

	c := aC
]

{ #category : 'accessing' }
MTTestObjectA >> initialize [ 

	super initialize.
	lst := OrderedCollection new.
]

{ #category : 'accessing' }
MTTestObjectA >> lfloat: anObject [

	lfloat := anObject
]

{ #category : 'accessing' }
MTTestObjectA >> lint [
	^ lint
]

{ #category : 'accessing' }
MTTestObjectA >> lint: anObject [

	lint := anObject
]

{ #category : 'accessing' }
MTTestObjectA >> lst [

	^ lst
]

{ #category : 'accessing' }
MTTestObjectA >> lst: anObject [

	lst := anObject
]

{ #category : 'accessing' }
MTTestObjectA >> lstring: anObject [

	lstring := anObject
]
