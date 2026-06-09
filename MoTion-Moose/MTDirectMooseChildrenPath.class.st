Class {
	#name : 'MTDirectMooseChildrenPath',
	#superclass : 'MTDirectChildrenPath',
	#category : 'MoTion-Moose-paths',
	#package : 'MoTion-Moose',
	#tag : 'paths'
}

{ #category : 'testing' }
MTDirectMooseChildrenPath >> isMooseObjectPath [

	^ true
]

{ #category : 'testing' }
MTDirectMooseChildrenPath >> resolveFrom: anObject [

	^ anObject computeChildren asArray
]
