"
Finally, there is another operator for Logical matcher: `orMatches:`. It allows to express a disjunction of two patterns (one or the other match). (Remember that percentage implements a conjunction of patterns within the curly braces.)
````
ClassA % {
	#someProperty <=> (5 orMatches: 6)
}
```
This pattern matches an instance of 'ClassA' with a property someProperty matching the value 5 or the value 6.
"
Class {
	#name : 'OrMatcher',
	#superclass : 'LogicalMatcher',
	#category : 'MoTion-matcher',
	#package : 'MoTion',
	#tag : 'matcher'
}

{ #category : 'matching' }
OrMatcher >> match: aValue withContext: aMatchingContext [

	| results |
	results := left match: aValue withContext: aMatchingContext.
	(results anySatisfy: #isMatch) ifTrue: [ ^ results ].
	^ right match: aValue withContext: aMatchingContext
]
