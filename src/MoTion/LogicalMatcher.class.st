Class {
	#name : 'LogicalMatcher',
	#superclass : 'Matcher',
	#instVars : [
		'left',
		'right'
	],
	#category : 'MoTion-matcher',
	#package : 'MoTion',
	#tag : 'matcher'
}

{ #category : 'comparing' }
LogicalMatcher class >> between: leftMatcher and: rightMatcher [

	^ self new
		  left: leftMatcher;
		  right: rightMatcher;
		  yourself
]

{ #category : 'accessing' }
LogicalMatcher >> left [
	^ left
	
]

{ #category : 'accessing' }
LogicalMatcher >> left: aMatcher [
 	left := aMatcher
]

{ #category : 'accessing' }
LogicalMatcher >> right [
	^ right
]

{ #category : 'accessing' }
LogicalMatcher >> right: aMatcher [

	right := aMatcher
]
