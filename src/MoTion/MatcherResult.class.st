"
""This class is used to handle the matchingContexts returned as collection after each match""
"
Class {
	#name : 'MatcherResult',
	#superclass : 'Object',
	#instVars : [
		'matchingContexts'
	],
	#category : 'MoTion-results',
	#package : 'MoTion',
	#tag : 'results'
}

{ #category : 'accessing' }
MatcherResult >> addAllIfMatch: allMatchingContexts [
	
	allMatchingContexts do:[ :each | self addIfMatch: each ]
]

{ #category : 'accessing' }
MatcherResult >> addIfMatch: aMatchingContext [

	aMatchingContext isMatch 
		ifFalse: [ ^ self ].
	matchingContexts add: aMatchingContext  
]

{ #category : 'accessing' }
MatcherResult >> bindingsFor: aString [

	^ (self matchingContexts collect: [ :context | 
		   context bindings at: aString ]) removeDuplicates
]

{ #category : 'initialization' }
MatcherResult >> initialize [ 
	matchingContexts := OrderedCollection new.
]

{ #category : 'accessing' }
MatcherResult >> isMatch [ 
	
	"allStatisfy loops over an array and return true if all the elements of the collection have true properties  "
	
	^ matchingContexts isNotEmpty and: [ matchingContexts allSatisfy: [ :each | each isMatch ]]
]

{ #category : 'accessors' }
MatcherResult >> matchingContexts [
	^ matchingContexts
]
