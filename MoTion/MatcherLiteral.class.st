"
This class represents Pharo literals used as patterns. For example `‘A sample text here’ asMatcher` and `1 asMatcher`. Literal patterns match exactly their literal value. This is useful for specifying the value that a property of an object must have.
"
Class {
	#name : 'MatcherLiteral',
	#superclass : 'Matcher',
	#instVars : [
		'value'
	],
	#category : 'MoTion-matcher',
	#package : 'MoTion',
	#tag : 'matcher'
}

{ #category : 'accessing' }
MatcherLiteral >> value [

	^ value
]

{ #category : 'accessing' }
MatcherLiteral >> value: aValue [

	value := aValue 
]
