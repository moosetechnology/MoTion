"
Internal helper describing one removable matcher constraint collected during inspection.
"
Class {
	#name : 'MatcherInspectableConstraint',
	#superclass : 'Object',
	#instVars : [
		'depth',
		'order',
		'description',
		'navigationPath'
	],
	#category : 'MoTion',
	#package : 'MoTion'
}

{ #category : 'instance creation' }
MatcherInspectableConstraint class >> navigationPath: aPath depth: anInteger order: anotherInteger description: aString [

	^ self new
		  navigationPath: aPath;
		  depth: anInteger;
		  order: anotherInteger;
		  description: aString;
		  yourself
]

{ #category : 'accessing' }
MatcherInspectableConstraint >> depth [

	^ depth
]

{ #category : 'accessing' }
MatcherInspectableConstraint >> depth: anInteger [

	depth := anInteger
]

{ #category : 'accessing' }
MatcherInspectableConstraint >> description [

	^ description
]

{ #category : 'accessing' }
MatcherInspectableConstraint >> description: aString [

	description := aString
]

{ #category : 'accessing' }
MatcherInspectableConstraint >> navigationPath [

	^ navigationPath
]

{ #category : 'accessing' }
MatcherInspectableConstraint >> navigationPath: anObject [

	navigationPath := anObject
]

{ #category : 'accessing' }
MatcherInspectableConstraint >> order [

	^ order
]

{ #category : 'accessing' }
MatcherInspectableConstraint >> order: anInteger [

	order := anInteger
]

{ #category : 'printing' }
MatcherInspectableConstraint >> printOn: aStream [

	aStream
		nextPutAll: self class name;
		nextPutAll: '(';
		nextPutAll: description;
		nextPut: $)
]
