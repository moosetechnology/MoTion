Extension { #name : 'Class' }

{ #category : '*MoTion' }
Class >> % aMatcherDescription [

	((self allSuperclasses collect: #name) includes: #MooseObject) 
		ifTrue: [ 
		^ MatcherMooseObject type: self withProperties: aMatcherDescription ].
	^ MatcherObject type: self withProperties: aMatcherDescription
]

{ #category : '*MoTion' }
Class >> %% aMatcherDescription [

	| matcher |
	matcher := ((self allSuperclasses collect: #name) includes:
		            #MooseObject)
		           ifTrue: [
				           (MatcherMooseObject
					            type: self
					            withProperties: aMatcherDescription)
					           subclassmatch: true;
					           yourself ]
		           ifFalse: [
				           (MatcherObject
					            type: self
					            withProperties: aMatcherDescription)
					           subclassmatch: true;
					           yourself ].
	MatcherOriginalDescriptionStore
		captureMatcherDescriptionFor: matcher
		class: self
		properties: aMatcherDescription
		subclassmatch: true.
	^ matcher
]

{ #category : '*MoTion' }
Class >> asMatcher [
	^ self
]

{ #category : '*MoTion' }
Class >> isInstanceWithProperties: aMatcherDescription [

	^ self % aMatcherDescription
]

{ #category : '*MoTion' }
Class >> isKindOfWithProperties: aMatcherDescription [

	^ self %% aMatcherDescription
]
