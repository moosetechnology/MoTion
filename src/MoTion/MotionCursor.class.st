Class {
	#name : 'MotionCursor',
	#superclass : 'Object',
	#instVars : [
		'subjectCursor',
		'subjectSize',
		'patternCursor',
		'patternSize',
		'hasNext',
		'forward',
		'lvStarts',
		'lvLengths',
		'lvMinLengths',
		'lvMaxLengths',
		'numberOfNonListWildcards',
		'aMatchingContextCombination',
		'contexts',
		'originalContext',
		'patternHasNext',
		'listWildcardsPositions'
	],
	#category : 'MoTion-paths',
	#package : 'MoTion',
	#tag : 'paths'
}

{ #category : 'accessing' }
MotionCursor >> addContextToPattern: manyContexts [
	(contexts at: self patternCursor) addAll: manyContexts.
]

{ #category : 'accessing' }
MotionCursor >> clearContextsForCurrentPattern [
	| index |
	index := self patternCursor.
	index < 1 ifTrue: [ ^ self ].
	(contexts at: index) removeAll.
]

{ #category : 'accessing' }
MotionCursor >> clearContextsForPreviousPattern [
	| index |
	index := self patternCursor.
	index < 1 ifTrue: [ ^ self ].
	(contexts at: index - 1) removeAll.
]

{ #category : 'accessing' }
MotionCursor >> contextForCurrentPattern [
	^ self contextForPattern: (self patternCursor - 1)
]

{ #category : 'accessing' }
MotionCursor >> contextForPattern: aNumber [
	aNumber <=0 ifTrue: [ ^ { originalContext } ].
	^ contexts at: aNumber
]

{ #category : 'accessing' }
MotionCursor >> decrementPatternCursor [

	patternCursor := patternCursor - 1
]

{ #category : 'accessing' }
MotionCursor >> decrementSubjectCursor [

	subjectCursor := subjectCursor - 1
]

{ #category : 'accessing' }
MotionCursor >> forward [

	^ forward
]

{ #category : 'accessing' }
MotionCursor >> forward: anObject [

	forward := anObject
]

{ #category : 'accessing' }
MotionCursor >> hasNext [

	^ hasNext
]

{ #category : 'accessing' }
MotionCursor >> hasNext: anObject [

	hasNext := anObject
]

{ #category : 'accessing' }
MotionCursor >> hasNextForCurrentPattern [
	^ patternHasNext at: self patternCursor
]

{ #category : 'accessing' }
MotionCursor >> incrementPatternCursor [

	patternCursor := patternCursor + 1
]

{ #category : 'accessing' }
MotionCursor >> incrementSubjectCursor [

	subjectCursor := subjectCursor + 1
]

{ #category : 'accessing' }
MotionCursor >> initCursorLengths [
 		
	listWildcardsPositions do: [ :i |  
		lvMinLengths at: i put: 0.
		lvMaxLengths at: i put: (subjectSize - numberOfNonListWildcards).
		lvStarts at: i put: 1.
		lvLengths at: i put: 0.
	]
	"1 to: patternSize do: [ :i  | 
		(matcherSequence at: i)	isListWildcard ifTrue: [  
			aMotionCursor lvMinLengths at: i put: 0.
			aMotionCursor lvMaxLengths at: i put: (aMotionCursor subjectSize - aMotionCursor numberOfNonListWildcards).
			aMotionCursor lvStarts at: i put: 1.
			aMotionCursor lvLengths at: i put: 0.
		].	
	]."
]

{ #category : 'accessing' }
MotionCursor >> initializeForMatcher: matcher withCollection: aCollection andOriginalContext: origContext [

	subjectSize := aCollection size.
	patternSize := matcher matcherSequence size.
	lvStarts := Array new: patternSize.
	lvLengths := Array new: patternSize.
	lvMinLengths := Array new: patternSize.
	lvMaxLengths := Array new: patternSize.
	subjectCursor := 1.
	patternCursor := 1.
	listWildcardsPositions := matcher listWildcardPositions.
	numberOfNonListWildcards := patternSize - listWildcardsPositions size.
	hasNext := true.
	forward := true.
	originalContext := origContext.

	contexts := (1 to: patternSize) collect: [ :i | 
		            OrderedCollection new ].
	patternHasNext := (1 to: patternSize) collect: [ :i | true ].

	self initCursorLengths
]

{ #category : 'accessing' }
MotionCursor >> lvLengths [

	^ lvLengths
]

{ #category : 'accessing' }
MotionCursor >> lvMaxLengths [

	^ lvMaxLengths
]

{ #category : 'accessing' }
MotionCursor >> lvMinLengths [

	^ lvMinLengths
]

{ #category : 'accessing' }
MotionCursor >> lvStarts [

	^ lvStarts
]

{ #category : 'accessing' }
MotionCursor >> patternCursor [

	^ patternCursor
]

{ #category : 'accessing' }
MotionCursor >> patternSize [

	^ patternSize
]

{ #category : 'accessing' }
MotionCursor >> resetHasNextForCurrentPattern [

	patternHasNext at: self patternCursor put: true
]

{ #category : 'accessing' }
MotionCursor >> setBackward [
	forward := false
]

{ #category : 'accessing' }
MotionCursor >> setForward [
	forward := true
]

{ #category : 'accessing' }
MotionCursor >> setHasNextForCurrentPattern [

	patternHasNext at: self patternCursor put: false
]

{ #category : 'accessing' }
MotionCursor >> subjectCursor [

	^ subjectCursor
]

{ #category : 'accessing' }
MotionCursor >> subjectCursor: anObject [

	subjectCursor := anObject
]

{ #category : 'accessing' }
MotionCursor >> subjectSize [

	^ subjectSize
]
