Class {
	#name : 'MatcherLiteralSymbol',
	#superclass : 'MatcherLiteral',
	#category : 'MoTion-matcher',
	#package : 'MoTion',
	#tag : 'matcher'
}

{ #category : 'instance creation' }
MatcherLiteralSymbol class >> of: aSymbol [
    ^ self new value: aSymbol
]

{ #category : 'matching' }
MatcherLiteralSymbol >> match: aNewValue withContext: aContext [

	aNewValue isString
		ifTrue: [ self matchOnlySymbol: aNewValue withContext: aContext ]
		ifFalse: [ 
			aNewValue isCollection & aNewValue isNotNil
				ifTrue: [ 
				self matchCollectionOfSymbols: aNewValue withContext: aContext ]
				ifFalse: [ aContext isMatch: false ] ].

	^ { aContext }
]

{ #category : 'matching' }
MatcherLiteralSymbol >> matchCollectionOfSymbols: aCollectionOfSymbols withContext: aContext [

	aCollectionOfSymbols do: [ :each | 
		each isSymbol ifTrue: [ "ifFalse: [ here we have to check if it is symbol like #name .... for the customStringMatcher]"
			self matchOnlySymbol: each withContext: aContext.
			aContext isMatch ifTrue: [ ^ self ] ] ]
]

{ #category : 'matching' }
MatcherLiteralSymbol >> matchOnlySymbol: aSymbol withContext: aContext [
	
	| sizeFound |
	sizeFound := aSymbol asString findString: value.

	aContext isMatch:
		(value = aSymbol or: [ (aSymbol asString findString: value) > 0 ])
]
