Class {
	#name : 'MTRecursiveMooseChildrenPath',
	#superclass : 'MTRecursiveChildrenPath',
	#category : 'MoTion-Moose-paths',
	#package : 'MoTion-Moose',
	#tag : 'paths'
}

{ #category : 'testing' }
MTRecursiveMooseChildrenPath >> isMooseObjectPath [

	^ true
]

{ #category : 'testing' }
MTRecursiveMooseChildrenPath >> resolveFrom: anObject [

	^ anObject computeAllChildren asArray
]
