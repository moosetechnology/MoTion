Class {
	#name : 'MatcherLiteralNumber',
	#superclass : 'MatcherLiteral',
	#category : 'MoTion-matcher',
	#package : 'MoTion',
	#tag : 'matcher'
}

{ #category : 'as yet unclassified' }
MatcherLiteralNumber class >> matching: aValue [
 ^self new 
  value: aValue ; 
  yourself 
]

{ #category : 'instance creation' }
MatcherLiteralNumber class >> of: aValue [ 
	   ^ self new
		  value: aValue;
		  yourself
]

{ #category : 'matching' }
MatcherLiteralNumber >> match: aNewValue withContext: aContext [
	 		
	"a Number matcher can either fully match a Number or can be available in a list of Numbers. So the first condition is used to match only one number while the second one is checking if the number exists in a collection of given numbers. If a match is found, aContext isMatch is returned as True. "
	
   aNewValue isNumber 
		ifTrue: [ self matchOnlyNumber: aNewValue withContext: aContext]
		ifFalse: [
				(aNewValue isCollection and:[(aNewValue  isNotNil)])
					ifTrue: [self matchCollectionOfNumbers: aNewValue withContext: aContext] 
					ifFalse: [ aContext isMatch: false ]
			].
	 	
	^ { aContext }
]

{ #category : 'matching' }
MatcherLiteralNumber >> matchCollectionOfNumbers: aCollectionOfLiterals withContext: aContext [

	aCollectionOfLiterals do: [ :each | 
		each isNumber ifTrue: [ 
			self matchOnlyNumber: each withContext: aContext.
			aContext isMatch ifTrue: [ ^ self ] 
			] 
	]
]

{ #category : 'matching' }
MatcherLiteralNumber >> matchOnlyNumber: aNumber withContext: aContext [

	aContext isMatch: aNumber = value
]
