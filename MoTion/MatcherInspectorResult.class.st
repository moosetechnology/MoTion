"
Stores the result of inspecting a matcher against one instance by testing progressively relaxed matcher variants.
"
Class {
	#name : 'MatcherInspectorResult',
	#superclass : 'Object',
	#instVars : [
		'originalResult',
		'suspiciousConstraint',
		'suspiciousConstraintDescription',
		'testedConstraints',
		'message',
		'successfulResult'
	],
	#category : 'MoTion',
	#package : 'MoTion'
}

{ #category : 'testing' }
MatcherInspectorResult >> foundSuspiciousConstraint [

	^ suspiciousConstraint notNil
]

{ #category : 'testing' }
MatcherInspectorResult >> isMatch [

	^ originalResult notNil and: [ originalResult isMatch ]
]

{ #category : 'accessing' }
MatcherInspectorResult >> message [

	^ message
]

{ #category : 'accessing' }
MatcherInspectorResult >> message: aString [

	message := aString
]

{ #category : 'accessing' }
MatcherInspectorResult >> originalResult [

	^ originalResult
]

{ #category : 'accessing' }
MatcherInspectorResult >> originalResult: aMatcherResult [

	originalResult := aMatcherResult
]

{ #category : 'printing' }
MatcherInspectorResult >> printOn: aStream [

	aStream nextPutAll: self class name.
	message ifNotNil: [
			aStream
				nextPutAll: '(';
				nextPutAll: message;
				nextPut: $) ]
]

{ #category : 'accessing' }
MatcherInspectorResult >> successfulResult [

	^ successfulResult
]

{ #category : 'accessing' }
MatcherInspectorResult >> successfulResult: aMatcherResult [

	successfulResult := aMatcherResult
]

{ #category : 'accessing' }
MatcherInspectorResult >> suspiciousConstraint [

	^ suspiciousConstraint
]

{ #category : 'accessing' }
MatcherInspectorResult >> suspiciousConstraint: anInspectableConstraint [

	suspiciousConstraint := anInspectableConstraint
]

{ #category : 'accessing' }
MatcherInspectorResult >> suspiciousConstraintDescription [

	^ suspiciousConstraintDescription
]

{ #category : 'accessing' }
MatcherInspectorResult >> suspiciousConstraintDescription: aString [

	suspiciousConstraintDescription := aString
]

{ #category : 'accessing' }
MatcherInspectorResult >> testedConstraints [

	^ testedConstraints ifNil: [ #(  ) ]
]

{ #category : 'accessing' }
MatcherInspectorResult >> testedConstraints: aCollection [

	testedConstraints := aCollection
]

{ #category : 'accessing' }
MatcherInspectorResult >> testedConstraintsCount [

	^ self testedConstraints size
]
