Class {
	#name : 'MTTestObjectC',
	#superclass : 'Object',
	#instVars : [
		'a',
		'lint',
		'lstring',
		'lfloat',
		'llist'
	],
	#category : 'MoTion-Tests-class-data-tests',
	#package : 'MoTion-Tests',
	#tag : 'class-data-tests'
}

{ #category : 'accessing' }
MTTestObjectC >> a: aA [
	a := aA
]

{ #category : 'accessing' }
MTTestObjectC >> lfloat: anObject [

	lfloat := anObject
]

{ #category : 'accessing' }
MTTestObjectC >> lint: anObject [

	lint := anObject
]

{ #category : 'accessing' }
MTTestObjectC >> llist [

	^ llist
]

{ #category : 'accessing' }
MTTestObjectC >> llist: anObject [ 

	llist := anObject
]

{ #category : 'accessing' }
MTTestObjectC >> lstring: anObject [

	lstring := anObject
]
