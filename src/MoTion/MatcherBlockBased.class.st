Class {
	#name : 'MatcherBlockBased',
	#superclass : 'Matcher',
	#instVars : [
		'block'
	],
	#category : 'MoTion-matcher',
	#package : 'MoTion',
	#tag : 'matcher'
}

{ #category : 'instance creation' }
MatcherBlockBased class >> of: aBlock [

	^ self new
		  block: aBlock;
		  yourself
]

{ #category : 'accessing' }
MatcherBlockBased >> block [ 
	^ block
]

{ #category : 'accessing' }
MatcherBlockBased >> block: aBlock [

	block := aBlock
]

{ #category : 'accessing' }
MatcherBlockBased >> isBlockMatcher [

	^ true
]
