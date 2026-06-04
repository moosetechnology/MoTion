Class {
	#name : 'MTTestObjectD',
	#superclass : 'Object',
	#instVars : [
		'e',
		'f',
		'lint',
		'child'
	],
	#category : 'MoTion-Tests',
	#package : 'MoTion-Tests'
}

{ #category : 'accessing' }
MTTestObjectD >> child [

	^ child
]

{ #category : 'accessing' }
MTTestObjectD >> child: anObject [

	child := anObject
]

{ #category : 'accessing' }
MTTestObjectD >> e: anE [
    e := anE

]

{ #category : 'accessing' }
MTTestObjectD >> f: anF [
    f := anF
]

{ #category : 'accessing' }
MTTestObjectD >> lint: anInteger [
    lint := anInteger
]
