"
MoTion allows to perform Recursive traversal through a '*' operator combined with the Path traversal operator '>'. In a chain of objects, one may know the initial property and the final one, but not know how long the chain of objects is.
```
ClassA % {
	#'property1>repeatedProp*' <=> aValue.
}
```
This pattern will match first an instance of `ClassA`, then the object in its property `property1` then it will match a chain of objects all having a property `repeatedProp` and one of them containing the value `aValue`. The match ends with this last object.
"
Class {
	#name : 'MTRecursivePath',
	#superclass : 'MotionPath',
	#instVars : [
		'path'
	],
	#category : 'MoTion-paths',
	#package : 'MoTion',
	#tag : 'paths'
}

{ #category : 'instance creation' }
MTRecursivePath class >> of: aSymbol [

	^ self new name: aSymbol ; yourself 
]

{ #category : 'resolving' }
MTRecursivePath >> internalResolveFrom: anObject seen: seenObjects [

	| directObjects resultsCollection o |
	directObjects := {  } asOrderedCollection.
	o := (path resolveFrom: anObject) flattened.
	resultsCollection := (o isCollection and: [ 
		                      o isString not and: o isSymbol not ])
		                     ifFalse: [ { o } ]
		                     ifTrue: [ o ].
	resultsCollection := resultsCollection select: [ :each | 
		                     each isNotNil and: [ 
			                     (seenObjects includes: each) not ] ].
	directObjects addAll: resultsCollection.
	seenObjects addAll: resultsCollection.

	directObjects addAll: (directObjects flatCollect: [ :each | 
			 self internalResolveFrom: each seen: seenObjects ]).
	(seenObjects includes: anObject) ifFalse: [ 
		seenObjects add: anObject.
		"directObjects insert: anObject bee: 1 "].

	^ directObjects
]

{ #category : 'resolving' }
MTRecursivePath >> internalResolveFromBak: anObject seen: seenObjects [

	| directObjects o |
	directObjects := OrderedCollection new.
	o := (path resolveFrom: anObject) flattened.
	o ifNotNil: [ 
			(seenObjects includes: o) ifFalse: [ 
				directObjects addAll: o.
				seenObjects addAll: o ]].
		
	directObjects addAll: (directObjects flatCollect: [ :each | 
			 self internalResolveFrom: each seen: seenObjects ]).

	^ directObjects flattened 
]

{ #category : 'resolving' }
MTRecursivePath >> name: aSymbol [

	name := aSymbol.
	path := aSymbol asObjectPath
]

{ #category : 'resolving' }
MTRecursivePath >> resolveFrom: anObject [

	^ (self internalResolveFrom: anObject seen: IdentitySet new) asArray
]

{ #category : 'resolving' }
MTRecursivePath >> slotsToVisit: anObject [ 
	
	^ {anObject class slotNamed: name }
]
