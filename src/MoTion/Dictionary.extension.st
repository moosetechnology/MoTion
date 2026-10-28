Extension { #name : 'Dictionary' }

{ #category : '*MoTion' }
Dictionary >> filterKeys: aCollectionOfKeys [

	"Creates a new dictionnary with only the keys from aCollectionOfKeys"

	| copy |
	copy := self class new.
	aCollectionOfKeys do: [ :key | copy at: key put: (self at: key) ].
	^ copy
]
