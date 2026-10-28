"
This class is responsible of defining non-Linear patterns.
We can express them with MoTion syntax using the '@' operator followed by a name (for example: @x). This allows to store any object in the `aValue1` to reuse it somewhere else in the same pattern:
```
ClassA % {
	#'property1' <=> #'@aValue1'.
	#'property2' <=> #'@aValue1'.
}
```
"
Class {
	#name : 'MTIdentityPath',
	#superclass : 'MotionPath',
	#category : 'MoTion-paths',
	#package : 'MoTion',
	#tag : 'paths'
}

{ #category : 'initialization' }
MTIdentityPath >> initialize [
	name := #@.
]

{ #category : 'initialization' }
MTIdentityPath >> resolveFrom: anObject [
	^ { anObject } asArray 
]
