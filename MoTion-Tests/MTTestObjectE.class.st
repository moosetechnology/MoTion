Class {
	#name : 'MTTestObjectE',
	#superclass : 'Object',
	#instVars : [
		'g',
		'child'
	],
	#category : 'MoTion-Tests',
	#package : 'MoTion-Tests'
}

{ #category : 'accessing' }
MTTestObjectE >> child [

	^ child
]

{ #category : 'accessing' }
MTTestObjectE >> child: anObject [

	child := anObject
]

{ #category : 'accessing' }
MTTestObjectE >> g: aG [
    g := aG
]
