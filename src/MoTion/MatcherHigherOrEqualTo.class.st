Class {
	#name : 'MatcherHigherOrEqualTo',
	#superclass : 'MatcherLiteralNumber',
	#category : 'MoTion',
	#package : 'MoTion'
}

{ #category : 'matching' }
MatcherHigherOrEqualTo >> matchOnlyNumber: aNumber withContext: aContext [
    aContext isMatch: aNumber >= value
]
