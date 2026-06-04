"
It is possible to match List matching and declaring how the list should look like using {}. Note that this is not the same operator as %{} which is used to encapsulate properties and their values. This operator allows to express that given elements in a list should match specific patterns: `{#'@x'. #'@x'}`
This pattern matches a list containing exactly two elements that are the same (use of a named variable).

The repetition operator ('*') may also be used in a list to indicate an unspecified number of elements:
`{#'@x'. #'*_'. #'@x'}`. This pattern, matches a list with first and last elements equal and of unspecified length (obviously at least 2). Note that '*_' is used in list matching whereas '_*' is a repeated wildcard used in Recursive traversal.

To express that one element is part of a collection, MoTion offers a shortcut. To check if the value 5 is part of a collection (contained in the property someProperty of an instance of ClassA) one can use the pattern:
```
ClassA % {
	#someProperty <=> {#'*_'. 5. #'*_'}
}
```
But, thanks to the already presented polymorphism, of the spaceship operator, the same can be expressed with a shortcut:
```
ClassA % {
	#someProperty<=> 5
}
```
This, however, could also match an instance of ClassA with a property someProperty containing exactly the value 5 (with no collection).
"
Class {
	#name : 'MatcherCollection',
	#superclass : 'Matcher',
	#instVars : [
		'matcherSequence'
	],
	#category : 'MoTion-matcher',
	#package : 'MoTion',
	#tag : 'matcher'
}

{ #category : 'instance creation' }
MatcherCollection class >> of: aMatcherSequence [
	^ self new matcherSequence: aMatcherSequence; yourself
]

{ #category : 'matching' }
MatcherCollection >> hasListWildcards [ 
	^ self listWildcardPositions isNotEmpty
]

{ #category : 'matching' }
MatcherCollection >> initializeCursor: aMotionCursor withCollection: aCollection andOriginalContext: originalContext [
	aMotionCursor
		initializeForMatcher: self
		withCollection: aCollection
		andOriginalContext: originalContext
]

{ #category : 'matching' }
MatcherCollection >> isCollectionMatcher [
	^ true
]

{ #category : 'matching' }
MatcherCollection >> listWildcardPositions [

	| positions | 
	positions := OrderedCollection new.
	matcherSequence doWithIndex: [ :e :i | 
		e isListWildcard ifTrue: [ positions add: i ] ].
	^ positions
]

{ #category : 'matching' }
MatcherCollection >> match: aCollection withContext: aMatchingContext [

	| motionCursor results combinationFound |
	"results is a collection of matchingContexts" 
	results := OrderedCollection new.

	"initilazing the motionCursor"
	motionCursor := MotionCursor new.
	self
		initializeCursor: motionCursor
		withCollection: aCollection
		andOriginalContext: aMatchingContext.

	[ motionCursor hasNext ] whileTrue: [ "We enter this loop each time a combination is found to reset combination params in moTionCursor.""restting combination params "
		combinationFound := false.

		[ combinationFound not and: motionCursor hasNext ] whileTrue: [ "here we are looping until there are no combinations found. 
			results can contains false and true matchingContexts; true macthingContexts will be filtered when isMatch is called only."
			combinationFound := self
				                    matchNext: aCollection
				                    withCursor: motionCursor
				                    withContexts:
				                    motionCursor contextForCurrentPattern
				                    originalContext: aMatchingContext ].

		combinationFound ifTrue: [ 
			results addAll: motionCursor contextForCurrentPattern ].
		motionCursor forward: false ].
	^ results asArray
]

{ #category : 'matching' }
MatcherCollection >> matchNext: aCollection withCursor: aMotionCursor withContexts: matchContexts originalContext: originalContext [
| pattern contexts | 

contexts := matchContexts collect: [ :each | each copy ].

	"checking state of forward and cursors"
			"1- If forward and cursors reach the maximum then a combination is built "
			
			aMotionCursor forward ifTrue: [
				(aMotionCursor patternCursor > aMotionCursor patternSize) ifTrue: [ 
					(aMotionCursor subjectCursor > aMotionCursor subjectSize) ifTrue: [ 		 
							"!! here a full combination of matches is found."	
							^ true.
						].
					"here we have cannot go forward anymore as patternCursor reached the max but without matching all subjects, which is why we decrement patternCursor"
					aMotionCursor setBackward.
					aMotionCursor decrementPatternCursor.
					aMotionCursor clearContextsForCurrentPattern.
					].
				]
			ifFalse:[
				(aMotionCursor patternCursor >= aMotionCursor patternSize) ifTrue: [ 
					"decrement both and go back and patternCursor reaches the patternSize and subjectCursor reaches subjectSize."
					
					aMotionCursor decrementPatternCursor.
					aMotionCursor decrementSubjectCursor.
				]					
			]. 
		
			
			"2- If one of the cursors is negative --> this means that no more combinations are available anymore. hasNext will be set to false and the looping finishes"
			(aMotionCursor patternCursor < 1 or: [aMotionCursor subjectCursor < 1]) ifTrue: [ 
				aMotionCursor hasNext: false.
				^ false
			].
		
			"Get pattern and start checking its type: literal or listWildcard"
			pattern := matcherSequence at: aMotionCursor patternCursor.
			pattern isListWildcard ifFalse: [ 
				
				| newContexts |

				"Check if going forward & patternCursor didn't reach full size"
				(aMotionCursor forward and: [(aMotionCursor subjectCursor <= aMotionCursor subjectSize)] ) ifTrue: [ 
					
					aMotionCursor resetHasNextForCurrentPattern.
					aMotionCursor clearContextsForCurrentPattern.
					"Try to match by getting values based on patternCursor and subjectCursor"					
					newContexts := contexts flatCollect: [ :c | pattern match: (aCollection at: aMotionCursor subjectCursor) withContext: c ].
										
					(newContexts anySatisfy: #isMatch) 
						ifTrue: [  
										"Increment when there is a match"
										aMotionCursor setHasNextForCurrentPattern.
										contexts := newContexts select: #isMatch. 
										aMotionCursor addContextToPattern: contexts.
										aMotionCursor incrementPatternCursor.
										aMotionCursor incrementSubjectCursor.			
									] 
						ifFalse: [ 
										"decrement patternCursor if no match and set forward to false to force going back; 
										Only patternCursor bcz we want to to try matching a new pattern with same subjects"	 
										
										aMotionCursor decrementPatternCursor.
										aMotionCursor setBackward.
									].		
				
					] ifFalse: [   
						"in this case frward is false but we need to check if there is a match."
						(aMotionCursor subjectCursor  <= aMotionCursor subjectSize ) ifTrue:[ 
						
							newContexts := contexts flatCollect: [ :c | pattern match: (aCollection at: aMotionCursor subjectCursor) withContext: c ]. 
							(aMotionCursor hasNextForCurrentPattern and: [(newContexts anySatisfy: #isMatch)]) ifTrue: [ 		 
										contexts := newContexts select: #isMatch. 
										aMotionCursor resetHasNextForCurrentPattern.
										"increment everything"
										aMotionCursor addContextToPattern: contexts.
										aMotionCursor incrementPatternCursor.
										aMotionCursor incrementSubjectCursor.
										aMotionCursor setForward.																
							] 
						
							ifFalse:[ 
								"decrement everything bcz we're in state where forward is false."
								aMotionCursor decrementPatternCursor.
								aMotionCursor decrementSubjectCursor.
								aMotionCursor setBackward.
							].
											  
						] ifFalse:[ 
							"decrement everything"
							aMotionCursor decrementPatternCursor.
							aMotionCursor decrementSubjectCursor.	
							aMotionCursor setBackward.
						].
					].
												
			] 
			ifTrue: [ | start min max length subjects |
				"Set values of start min max ... before start using them"	
				aMotionCursor forward ifTrue:[
					"start = subjectCursor "
					aMotionCursor lvStarts at: aMotionCursor patternCursor put: aMotionCursor subjectCursor.
					
					"length of subjects to retrieve from original subjects list to match is:"					
					(aMotionCursor patternCursor = aMotionCursor patternSize) ifTrue: [  
						"if patternCursor is on last element then length = subjectSize - subjectCursor"
						aMotionCursor lvLengths at:aMotionCursor patternCursor put: (aMotionCursor subjectSize - (aMotionCursor subjectCursor - 1)).
					]
					ifFalse: [  
						"if not last, then length is = min length;"
						aMotionCursor lvLengths at:aMotionCursor patternCursor put: (aMotionCursor lvMinLengths at: aMotionCursor patternCursor).						
					].				
				]
				ifFalse: [ 
					"if not forward, set forward to True and increment"
					aMotionCursor lvLengths at:aMotionCursor patternCursor put: ((aMotionCursor lvLengths at:aMotionCursor patternCursor) + 1).
					aMotionCursor setForward.
					aMotionCursor clearContextsForCurrentPattern.
				].
			 
			
				"catch values and start looping"
				length := aMotionCursor lvLengths at: aMotionCursor patternCursor.
				start := aMotionCursor lvStarts at: aMotionCursor patternCursor.
				min := aMotionCursor lvMinLengths at: aMotionCursor patternCursor.
				max := aMotionCursor lvMaxLengths at: aMotionCursor patternCursor.
				 
				(length > max or: [((start - 1 + length ) >= (aMotionCursor subjectSize + 1))]) ifTrue:[
						"length failure --> this means we have to go back"
						
						aMotionCursor subjectCursor: start.
						aMotionCursor setBackward.
						aMotionCursor lvLengths at: aMotionCursor patternCursor put: 0.
						
						"decrement pattern Cursor"
						aMotionCursor decrementPatternCursor.
						aMotionCursor clearContextsForCurrentPattern .
					]
				ifFalse: [ 					
					"here we try to get subjects based on start and length"
					subjects := aCollection copyFrom: start to: (start + length -1 ). 	
					contexts := contexts flatCollect: [ :c | pattern match: subjects withContext: c ].
				 
					(contexts anySatisfy: #isMatch) ifTrue: [  
																			"on match success: increment subject cursor and get bindings as we are in wildcard case" 
																			contexts := contexts select: #isMatch.  
																			aMotionCursor addContextToPattern: contexts.
																			aMotionCursor incrementPatternCursor.
																			aMotionCursor subjectCursor: start + length.															
																	] 
															 		ifFalse: [ 
																			"on match failure: go back; reset length and decrement patternCursor." 
																			aMotionCursor setBackward.
																			aMotionCursor lvLengths at: aMotionCursor patternCursor put: 0.
																			aMotionCursor decrementPatternCursor.
																		].		
					 
				].				
			].
		^ false.

]

{ #category : 'matching' }
MatcherCollection >> matcherSequence [
	^ matcherSequence 
]

{ #category : 'matching' }
MatcherCollection >> matcherSequence: aSequence [

	matcherSequence := aSequence
]

{ #category : 'matching' }
MatcherCollection >> numberOfListWildcards [

	^ self listWildcardPositions size
]
