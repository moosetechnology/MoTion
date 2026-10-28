Class {
	#name : 'MTDirectPath',
	#superclass : 'MotionPath',
	#category : 'MoTion-paths',
	#package : 'MoTion',
	#tag : 'paths'
}

{ #category : 'instance creation' }
MTDirectPath class >> of: anObjectPathString [

	^ self new name: anObjectPathString asSymbol
]

{ #category : 'resolving' }
MTDirectPath >> resolveFrom: anObject [
	"^ { ([ (anObject class slotNamed: name) read: anObject ]
		   on: SlotNotFound
		   do: [ anObject perform: name ]) } flattened"

	| res |
	res := [
		       [
			       [ (anObject class slotNamed: name) read: anObject ]
				       on: SlotNotFound
				       do: [ anObject perform: name ] ]
			       on: Deprecation
			       do: [ :deprecation | deprecation resume ] ]
		       on: Exception
		       do: [ #(  ) ].

	^ { res } flattened
]
