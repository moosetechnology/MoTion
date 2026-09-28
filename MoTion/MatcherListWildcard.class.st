Class {
	#name : 'MatcherListWildcard',
	#superclass : 'MatcherWildcard',
	#category : 'MoTion-matcher',
	#package : 'MoTion',
	#tag : 'matcher'
}

{ #category : 'testing' }
MatcherListWildcard >> isListWildcard [ 
	^ true
]

{ #category : 'testing' }
MatcherListWildcard >> match: aNewValue withContext: aMatchingContext [

	| aResult |
	self isAnonymous ifTrue: [ 
		aMatchingContext isMatch: true.
		^ { aMatchingContext } ].

	aResult := aMatchingContext bindings at: alias ifAbsentPut: [ 
		           aMatchingContext isMatch: true.
		           aNewValue ].
	aMatchingContext isMatch: aResult = aNewValue.

	(aMatchingContext currentPropertyValues notNil
		and: [ aNewValue anySatisfy: [ :each | (each respondsTo: #startPos) not ] ]) ifTrue: [
		| owners | 
		"we enter this loop if the matched items (stored in currentPropertyValues) are not FAST items"
		owners := aNewValue collect: [ :each |
			(each respondsTo: #startPos)
				ifTrue: [ each 
					"in case the item is FAST item, so we return it as is"
					]
				ifFalse: [
					"here we look for the node of the item that is not FAST item, and we look for it in currentPropertyOwners which is using the resolveOwnerFrom: method to be filled; but first we have toi check if it exists in the currentPropertyOwners"
					| idx |
					idx := aMatchingContext currentPropertyValues indexOf: each ifAbsent: [ 0 ].
					idx > 0
						ifTrue: [ aMatchingContext currentPropertyOwners at: idx ifAbsent: [ nil ] ]
						ifFalse: [ nil ] ] ].
		aMatchingContext bindings
			at: (alias , 'NodeCollection') asSymbol
			ifAbsentPut: [ owners ] ].

	^ { aMatchingContext }
]
