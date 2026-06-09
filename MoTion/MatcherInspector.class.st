"
Inspects a matcher by progressively removing nested constraints from deepest to outermost until a relaxed matcher starts matching.
"
Class {
	#name : 'MatcherInspector',
	#superclass : 'Object',
	#instVars : [
		'order'
	],
	#category : 'MoTion',
	#package : 'MoTion'
}

{ #category : 'instance creation' }
MatcherInspector class >> inspect: aMatcher using: anInstance [

	^ self new inspect: aMatcher using: anInstance
]

{ #category : 'private' }
MatcherInspector >> collectCandidatesFrom: aPattern path: aPath depth: aDepth into: candidates [

	| ivarNames |
	ivarNames := aPattern class allInstVarNames.
	ivarNames doWithIndex: [ :ivarName :index |
			| value ivarPath |
			value := aPattern instVarAt: index.
			ivarPath := aPath copyWith: #ivar -> ivarName.
			(value isKindOf: Matcher) ifTrue: [
					self
						collectCandidatesFrom: value
						path: ivarPath
						depth: aDepth + 1
						into: candidates ].
			(self isInspectableCollection: value) ifTrue: [
					self
						collectCandidatesFromCollection: value
						path: ivarPath
						depth: aDepth + 1
						into: candidates ] ]
]

{ #category : 'private' }
MatcherInspector >> collectCandidatesFromCollection: aCollection path: aPath depth: aDepth into: candidates [

	aCollection doWithIndex: [ :each :index |
			| candidateMatcher matcherPath |
			candidateMatcher := self matcherRepresentedBy: each.
			candidateMatcher ifNotNil: [
					matcherPath := aPath copyWith: #index -> index.
					order := order + 1.
					candidates add: (MatcherInspectableConstraint
							 navigationPath: matcherPath
							 depth: aDepth
							 order: order
							 description: (self descriptionOfCollectionElement: each)).
					self
						collectCandidatesFrom: candidateMatcher
						path: matcherPath
						depth: aDepth + 1
						into: candidates ] ]
]

{ #category : 'private' }
MatcherInspector >> descriptionOfCollectionElement: anObject [

	^ MatcherOriginalDescriptionStore
		  descriptionFor: anObject
		  ifAbsent: [ anObject printString ]
]

{ #category : 'initialization' }
MatcherInspector >> initialize [

	super initialize.
	order := 0
]

{ #category : 'inspecting' }
MatcherInspector >> inspect: aPattern using: anInstance [

	| result candidates |
	
	"1- Check the matcher is returning positive results or not"
	result := MatcherInspectorResult new.
	result originalResult: (aPattern match: anInstance).
	result testedConstraints: #(  ).
	result isMatch ifTrue: [
			result message: 'Original matcher already matches the instance'.
			^ result ].
			
	"2- if not, continue"
	
	"3- here candidates are retrieved, candidates are the possible lines that can be commented"
	"candidates is a list of all removable MoTion constraints, ordered exactly as deepest first, and left-to-right for same level properties defined."
	
	candidates := self sortedCandidatesFrom: aPattern.	
	result testedConstraints: candidates.
	
	"4- here we are looping over candidates one by one in order to start the removal"
	candidates do: [ :candidate |
		
			| reducedPattern newResult |
			
			"5- this creates a new matcher that is the same as the original one, except that one chosen constraint has been removed. this is why it is called relaxed :p"
			reducedPattern := self reducedCopyOf: aPattern removing: candidate.
			
			"6- Try to match again with the new pattern"
			newResult := reducedPattern match: anInstance.
			
			"7- if the match succeeds then the issue was in the removed candidate"
			newResult isMatch ifTrue: [
					result suspiciousConstraint: candidate.
					result suspiciousConstraintDescription: candidate description.
					result successfulResult: newResult.
					result message:
						'The matcher starts matching when this constraint is removed'.
					^ result ] ].
	result message: 'No single constraint removal restored a match'.
	^ result
]

{ #category : 'private' }
MatcherInspector >> isInspectableCollection: anObject [

	^ anObject isCollection and: [
			  anObject isString not and: [
				  anObject isSymbol not and: [ anObject isDictionary not ] ] ]
]

{ #category : 'private' }
MatcherInspector >> matcherRepresentedBy: anObject [

	(anObject isKindOf: Matcher) ifTrue: [ ^ anObject ].
	(anObject isAssociation and: [ anObject value isKindOf: Matcher ])
		ifTrue: [ ^ anObject value ].
	^ nil
]

{ #category : 'private' }
MatcherInspector >> parentForConstraintPath: aPath in: aMatcher [
	"Walk through the matcher and return the matcher owning the constraint to remove."

	| current limit |
	current := aMatcher.
	limit := aPath size - 2.
	1 to: limit do: [ :offset |
			| step |
			step := aPath at: offset.
			step key = #ivar
				ifTrue: [
						current isAssociation ifTrue: [ current := current value ].
						current := current instVarNamed: step value ]
				ifFalse: [ current := current at: step value ] ].
	current isAssociation ifTrue: [ current := current value ].
	^ current
]

{ #category : 'private' }
MatcherInspector >> reducedCopyOf: aMatcher removing: aConstraint [
	"this is for removing a constraint"

	| matcherCopy parent ivarName collection index |
	matcherCopy := aMatcher veryDeepCopy.
	parent := self
		          parentForConstraintPath: aConstraint navigationPath
		          in: matcherCopy.
	ivarName := (aConstraint navigationPath at:
		             aConstraint navigationPath size - 1) value.
	collection := parent instVarNamed: ivarName.
	index := aConstraint navigationPath last value.
	self
		removeIndex: index
		from: collection
		in: parent
		ivarNamed: ivarName.
	^ matcherCopy
]

{ #category : 'private' }
MatcherInspector >> removeIndex: anInteger from: aCollection in: anObject ivarNamed: aString [

	(aCollection respondsTo: #removeAt:)
		ifTrue: [ aCollection removeAt: anInteger ]
		ifFalse: [
				anObject
					instVarNamed: aString
					put: (aCollection copyWithoutIndex: anInteger) ]
]

{ #category : 'private' }
MatcherInspector >> sortedCandidatesFrom: aMatcher [

	"important to sort the left and right"
	
	| candidates |
	order := 0.
	candidates := OrderedCollection new.
	self
		collectCandidatesFrom: aMatcher
		path: #(  )
		depth: 0
		into: candidates.
	^ candidates asSortedCollection: [ :left :right |
			  left depth = right depth
				  ifTrue: [ left order < right order ]
				  ifFalse: [ left depth > right depth ] ]
]
