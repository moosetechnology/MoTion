Class {
	#name : 'MatcherLessThan',
	#superclass : 'MatcherLiteralNumber',
	#category : 'MoTion',
	#package : 'MoTion'
}

{ #category : 'matching' }
MatcherLessThan >> matchOnlyNumber: aNumber withContext: aContext [
    aContext isMatch: aNumber < value
]
