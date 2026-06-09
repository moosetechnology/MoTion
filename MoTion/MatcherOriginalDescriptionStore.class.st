Class {
	#name : 'MatcherOriginalDescriptionStore',
	#superclass : 'Object',
	#category : 'MoTion',
	#package : 'MoTion'
}

{ #category : 'descriptions' }
MatcherOriginalDescriptionStore class >> captureAssociationDescriptionFor: anAssociation [

	^ self
		  captureDescription: anAssociation key printString , ' <=> '
			  , (self descriptionForOriginalPart: anAssociation value)
		  for: anAssociation
]

{ #category : 'registry' }
MatcherOriginalDescriptionStore class >> captureDescription: aString for: anObject [

	self registry at: anObject put: aString.
	^ anObject
]

{ #category : 'descriptions' }
MatcherOriginalDescriptionStore class >> captureMatcherDescriptionFor: aMatcher class: aClass properties: aProperties subclassmatch: aBoolean [
	
	^ self
		  captureDescription: (String streamContents: [ :stream |
					   stream
						   nextPutAll: aClass name;
						   nextPutAll: (aBoolean
								    ifTrue: [ ' %% { ' ]
								    ifFalse: [ ' % { ' ]).
					   aProperties doWithIndex: [ :each :index |
							   index > 1 ifTrue: [ stream nextPutAll: '. ' ].
							   stream nextPutAll: (self descriptionForOriginalPart: each) ].
					   stream nextPutAll: ' }' ])
		  for: aMatcher
]

{ #category : 'registry' }
MatcherOriginalDescriptionStore class >> descriptionFor: anObject ifAbsent: aBlock [

	^ self registry at: anObject ifAbsent: aBlock
]

{ #category : 'descriptions' }
MatcherOriginalDescriptionStore class >> descriptionForOriginalPart: anObject [

	^ self descriptionFor: anObject ifAbsent: [
			  anObject isAssociation ifTrue: [
					  ^ anObject key printString , ' <=> '
					    , (self descriptionForOriginalPart: anObject value) ].
			  (anObject isKindOf: Array) ifTrue: [
					  ^ String streamContents: [ :stream |
							    stream nextPutAll: '{ '.
							    anObject doWithIndex: [ :each :index |
									    index > 1 ifTrue: [ stream nextPutAll: '. ' ].
									    stream nextPutAll:
										    (self descriptionForOriginalPart: each) ].
							    stream nextPutAll: ' }' ] ].
			  (anObject isKindOf: OrderedCollection) ifTrue: [
					  ^ String streamContents: [ :stream |
							    stream nextPutAll: '{ '.
							    anObject doWithIndex: [ :each :index |
									    index > 1 ifTrue: [ stream nextPutAll: '. ' ].
									    stream nextPutAll:
										    (self descriptionForOriginalPart: each) ].
							    stream nextPutAll: ' }' ] ].
			  anObject printString ]
]

{ #category : 'registry' }
MatcherOriginalDescriptionStore class >> registry [
	
	^ Smalltalk globals
		  at: #MatcherOriginalDescriptionRegistry
		  ifAbsentPut: [ IdentityDictionary new ]
]
