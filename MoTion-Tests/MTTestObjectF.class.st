Class {
	#name : 'MTTestObjectF',
	#superclass : 'Object',
	#instVars : [
		'h',
		'child'
	],
	#category : 'MoTion-Tests',
	#package : 'MoTion-Tests'
}

{ #category : 'accessing' }
MTTestObjectF >> child [

	^ child
]

{ #category : 'accessing' }
MTTestObjectF >> child: anObject [

	child := anObject
]

{ #category : 'accessing' }
MTTestObjectF >> h: aH [
    h := aH
]
