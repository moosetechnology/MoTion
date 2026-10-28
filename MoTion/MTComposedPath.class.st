"
Composed path enables path traversal using the '>' operator between properties. This allows to chain multiple properties in a pattern. Such paths help reducing complex pattern’s expression, by accessing a chain of objects and their properties:
The following pattern first matches an instance of 'ClassA', then it takes the object in its `property1` and the value in `property2` of this second object. This value should match `aValue`.
```
ClassA % {
	#'property1>property2' <=> aValue.
}
```

This notation allows expressing in a concise way a path in a graph of objects. The same result could be obtained with the pattern:
```
ClassA % {
	#'property1' <=> Object %% {
		#'property2' <=> aValue
	}
}
```
Note that the '>' operator is also polymorphic. Similarly to '<=>', if one of the objects in the path is a collection, the operator will look for an element of this collection that allows to continue the search, that is to say that has a property matching the remaining part of the pattern.
"
Class {
	#name : 'MTComposedPath',
	#superclass : 'MotionPath',
	#instVars : [
		'paths'
	],
	#category : 'MoTion-paths',
	#package : 'MoTion',
	#tag : 'paths'
}

{ #category : 'instance creation' }
MTComposedPath class >> of: aCollectionOfPaths [

	^ self new
		  addAll: aCollectionOfPaths;
		  yourself
]

{ #category : 'initialization' }
MTComposedPath >> add: aMotionPath [

	paths add: aMotionPath
]

{ #category : 'initialization' }
MTComposedPath >> addAll: anCollectionOfPaths [
	paths addAll: anCollectionOfPaths 
]

{ #category : 'initialization' }
MTComposedPath >> initialize [

	paths := OrderedCollection new
]

{ #category : 'initialization' }
MTComposedPath >> resolveCollectionFrom: anObject [

	| tmpObjects copy |
	tmpObjects := { anObject } asOrderedCollection.
	paths do: [ :each | 
		copy := tmpObjects shallowCopy.
		tmpObjects removeAll.

		copy do: [ :intermediate | 
			| result |
			result := [ each resolveFrom: intermediate ]
				          on: Exception
				          do: [ #(  ) ].
			tmpObjects addAll: result flattened ] ].
	^ tmpObjects asArray
]

{ #category : 'initialization' }
MTComposedPath >> resolveFrom: anObject [

	| tmpObjects copy |
	tmpObjects := { anObject } asOrderedCollection.
	paths do: [ :each | 
		copy := tmpObjects shallowCopy.
		tmpObjects removeAll.

		copy do: [ :intermediate | 
			| result |
			result := [ each resolveFrom: intermediate ]
				          on: Exception
				          do: [ #(  ) ].
			tmpObjects addAll: result flattened ] ].
	^ tmpObjects asArray
]

{ #category : 'as yet unclassified' }
MTComposedPath >> resolveOwnerFrom: anObject [
	
	| tmpObjects copy |
	
	"this method runs only when we have composedPath; for example for children>sourceCode. It reads the path until before last property, which is in this case only children, and returns the matches for children that will logically be nodes instead of literals."
	
	tmpObjects := { anObject } asOrderedCollection.
	
	"allButLast is the difference between this method and normal resolveFrom: "
	paths allButLast do: [ :each |
		copy := tmpObjects shallowCopy.
		tmpObjects removeAll.
		copy do: [ :intermediate |
			
			| result |
			
			"so here we're resolving all paths except the last one."
			 
			result := [ each resolveFrom: intermediate ]
				on: Exception
				do: [ #() ].
			tmpObjects addAll: result flattened ] ].
	^ tmpObjects asArray
]
