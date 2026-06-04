Class {
	#name : 'MatcherSet',
	#superclass : 'Matcher',
	#instVars : [
		'matcherSequence'
	],
	#category : 'MoTion-matcher',
	#package : 'MoTion',
	#tag : 'matcher'
}

{ #category : 'instance creation' }
MatcherSet class >> of: aMatcherSequence [
	^ self new matcherSequence: aMatcherSequence; yourself
]

{ #category : 'converting' }
MatcherSet >> isCollectionMatcher [
	^ true
]

{ #category : 'matching' }
MatcherSet >> match: aCollection withContext: aMatchingContext [ 
	
	"The concept of this algo is to give all possible iterations of the subjects and try to match each time using list matcher which takes order into consideration."
	
	"pay attention; case when collection is empty is not handled yet !"
	
	"this is a very basic method; dangereous when having lage models and with many childrens. logic to be changed: will implement it in match:WithContext2:"
	
	| results patternChildren subjectIterations|

	results := OrderedCollection new.	
	subjectIterations := 	OrderedCollection new.	
	patternChildren := MatcherCollection new. 
	patternChildren matcherSequence: matcherSequence copy.
	
	"get all subjects iterations possible"
	aCollection permutationsDo: [ :each | 
		subjectIterations add:each copy.
	].
	 
	subjectIterations do: [ :each | 
		results add: (patternChildren match: each withContext: aMatchingContext).
		]. 
	
	
 	^ results flattened asArray 
]

{ #category : 'accessing' }
MatcherSet >> matcherSequence [

	^ matcherSequence
]

{ #category : 'accessing' }
MatcherSet >> matcherSequence: anObject [

	matcherSequence := anObject
]
