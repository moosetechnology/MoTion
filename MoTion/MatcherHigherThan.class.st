Class {
	#name : 'MatcherHigherThan',
	#superclass : 'MatcherLiteralNumber',
	#category : 'MoTion',
	#package : 'MoTion'
}

{ #category : 'instance creation' }
MatcherHigherThan class >> of: aValue [

	^ self new value: aValue; 
	yourself 
]

{ #category : 'matching' }
MatcherHigherThan >> matchOnlyNumber: aNumber withContext: aContext [
    aContext isMatch: aNumber > value
]
