Class {
	#name : 'MatcherDebug',
	#superclass : 'Matcher',
	#instVars : [
		'innerMatcher'
	],
	#category : 'MoTion-matcher',
	#package : 'MoTion',
	#tag : 'matcher'
}

{ #category : 'instance creation' }
MatcherDebug class >> of: aMatcher [
	^ self new wrap: aMatcher
]

{ #category : 'matching' }
MatcherDebug >> isCollectionMatcher [ 
	^ innerMatcher isCollectionMatcher 
]

{ #category : 'matching' }
MatcherDebug >> match: anObject withContext: aMatchingContext [ 
	^ innerMatcher match: anObject withContext: aMatchingContext
]

{ #category : 'matching' }
MatcherDebug >> wrap: aMatcher [

	innerMatcher := aMatcher
]
