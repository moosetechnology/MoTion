Class {
	#name : 'MatcherLessThanOrEqualTo',
	#superclass : 'MatcherLiteralNumber',
	#category : 'MoTion',
	#package : 'MoTion'
}

{ #category : 'matching' }
MatcherLessThanOrEqualTo >> matchOnlyNumber: aNumber withContext: aContext [
    aContext isMatch: aNumber <= value
]
