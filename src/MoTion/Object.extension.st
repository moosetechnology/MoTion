Extension { #name : 'Object' }

{ #category : '*MoTion' }
Object >> <=> aMatcherObject [
	"The SpaceShip operator tries to match a property (of an object) on the left with a value on the right. 
	It is a polymorphic operator depending on the content in the Property. If this is an object, the operator tries to match this object to the Value; If it is a collection, the operator tries to match any element of the collection to the Value."
	
	| association |
	association := self -> aMatcherObject.
	MatcherOriginalDescriptionStore captureAssociationDescriptionFor:
		association.
	^ association
]

{ #category : '*MoTion' }
Object >> <~=> aMatcherObject [
	
	"the tilde version is a negation of the spaceship, it specifies that the Property should not match the Value; It is the only way to specify a negation in MoTion."
	
	^  self -> (MatcherNAC of: aMatcherObject asMatcher)
]

{ #category : '*MoTion' }
Object >> case: aPattern do: aBlock [

	| matchingResult |
	matchingResult := aPattern match: self.
	matchingResult isMatch ifFalse: [ ^ self ].
	aBlock value: matchingResult.
	^ aBlock 
]

{ #category : '*MoTion' }
Object >> defaultDo: aBlock [
   ^ aBlock value.
]

{ #category : '*MoTion' }
Object >> objectDoesNotMatch: aMatcherObject [
	^  self <~=> aMatcherObject 
]

{ #category : '*MoTion' }
Object >> objectMatches: aMatcherObject [
	^ self <=> aMatcherObject
]
