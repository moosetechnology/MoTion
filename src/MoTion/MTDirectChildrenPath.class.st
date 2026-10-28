Class {
	#name : 'MTDirectChildrenPath',
	#superclass : 'MotionPath',
	#category : 'MoTion-paths',
	#package : 'MoTion',
	#tag : 'paths'
}

{ #category : 'resolving' }
MTDirectChildrenPath >> resolveFrom: anObject [

	^ (anObject class allSlots flatCollectAsSet: [ :slot | 
		   | result |
		   result := slot read: anObject.
		   result ifNil: [ #(  ) ] ifNotNil: [ 
			   (result isCollection and: [ result isString not ])
				   ifTrue: [ result ]
				   ifFalse: [ { result } ] ] ]) asArray
]
