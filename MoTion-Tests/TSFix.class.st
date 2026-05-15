Class {
	#name : 'TSFix',
	#superclass : 'Object',
	#instVars : [
		'startPos',
		'endPos',
		'content'
	],
	#category : 'MoTion-Tests',
	#package : 'MoTion-Tests'
}

{ #category : 'applying' }
TSFix >> applyOn: aSource [
    ^ aSource 
        copyReplaceFrom: startPos 
        to: endPos 
        with: content.
]

{ #category : 'accessing' }
TSFix >> content: aString [
    content := aString.
]

{ #category : 'accessing' }
TSFix >> endPos: anInteger [
    endPos := anInteger.
]

{ #category : 'accessing' }
TSFix >> startPos: anInteger [
    startPos := anInteger.
]
