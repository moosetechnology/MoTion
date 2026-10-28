Class {
	#name : 'MatcherConditional',
	#superclass : 'MatcherBlockBased',
	#instVars : [
		'matchlist'
	],
	#category : 'MoTion-matcher',
	#package : 'MoTion',
	#tag : 'matcher'
}

{ #category : 'as yet unclassified' }
MatcherConditional class >> of: aBlock onList: aBoolean [

	^ self new
		  block: aBlock;
		  matchlist: aBoolean;
		  yourself
]

{ #category : 'as yet unclassified' }
MatcherConditional class >> onList: aBlock [

	^ self new
		  block: aBlock;
		  matchlist: true;
		  yourself
]

{ #category : 'testing' }
MatcherConditional >> initialize [
	super initialize.
	
	matchlist := false.
]

{ #category : 'testing' }
MatcherConditional >> isBlockMatcher [
	^ block arguments size > 1
]

{ #category : 'testing' }
MatcherConditional >> isCollectionMatcher [
	^ matchlist 
]

{ #category : 'testing' }
MatcherConditional >> match: anObject withContext: aContext [

	| args |
	args := block argumentNames allButFirst collect: [ :name | 
		        aContext bindings at: name ].
	aContext isMatch:
		(block valueWithArguments: { anObject } , args asArray).

	^ { aContext }
]

{ #category : 'testing' }
MatcherConditional >> matchlist: aBoolean [
	matchlist := aBoolean
]
