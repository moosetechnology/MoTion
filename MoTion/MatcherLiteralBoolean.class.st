Class {
	#name : 'MatcherLiteralBoolean',
	#superclass : 'MatcherLiteral',
	#category : 'MoTion-matcher',
	#package : 'MoTion',
	#tag : 'matcher'
}

{ #category : 'instance creation' }
MatcherLiteralBoolean class >> of: aBoolean [

	^ self new value: aBoolean 
]

{ #category : 'matching' }
MatcherLiteralBoolean >> match: aValue withContext: aContext [

	aContext isMatch: aValue = value.

	^ { aContext }
]
