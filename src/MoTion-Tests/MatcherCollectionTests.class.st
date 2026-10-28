Class {
	#name : 'MatcherCollectionTests',
	#superclass : 'MatcherTests',
	#category : 'MoTion-Tests-matchers',
	#package : 'MoTion-Tests',
	#tag : 'matchers'
}

{ #category : 'tests - to be refined' }
MatcherCollectionTests >> testCollectionWithSimpleObject [

	| matcher expression |
	expression := RBParser parseExpression: 'a. b.'.

	matcher := { 
		           (RBVariableNode % { (#name <=> 'a') }).
		           (RBVariableNode % { (#name <=> 'b') }) } asMatcher.

	self assert: (matcher match: expression children) isMatch
]

{ #category : 'tests - to be refined' }
MatcherCollectionTests >> testListPatternAtBeginning [

	| matcher result |
	matcher := { 30. #'*l2' } asMatcher.
	
	result := matcher match: #(10 20 30 30 40 50).
	
	self assert: result isMatch not
]

{ #category : 'tests - to be refined' }
MatcherCollectionTests >> testListWildcardDetection [

	| matcher result |
	matcher := { #'*l1'. 30. #'*l2' } asMatcher.
	
	result := matcher match: #(10 20 30 30 40 50).
	
	self assert: result isMatch.
	self assert: result matchingContexts size equals: 2
]

{ #category : 'tests - to be refined' }
MatcherCollectionTests >> testListWildcardWithInnerMatcher [

	| matcher result a1|
	matcher := { 
		#'*l1'. 
		#'@x'. 
		MTTestObjectA % { 
			#lint <=> #'@y' .
		}  
	} asMatcher.
	
	a1 := MTTestObjectA new lint: 5; yourself.
	a1 lst add: (MTTestObjectA new lint: 6; yourself).
	a1 lst add: (MTTestObjectA new lint: 6; yourself).
		
	result := matcher match: {1. 6. a1}. 
	self assert: result isMatch.
	self assert: result matchingContexts size equals: 1

]

{ #category : 'tests - to be refined' }
MatcherCollectionTests >> testListWildcardWithInnerMatcher2 [

	| matcher result |
	matcher := { 
		#'*l1'.
		#'@x'.
	} asMatcher.
		
	result := matcher match: #(1 6 7). 
	self assert: result isMatch.
	self assert: result matchingContexts size equals: 1

]

{ #category : 'tests - to be refined' }
MatcherCollectionTests >> testListWildcardWithInnerMatcher3 [

	| matcher result a1 bindings |
	matcher := { 
		#'*l1'. 
		#'@x'. 
		MTTestObjectA % { 
			#lint <=> #'@y' .
			#'_*' <=> MTTestObjectA % { 
				#lint <=> #'@x'.
			} as: #z.
		}  
	} asMatcher.
	
	a1 := MTTestObjectA new lint: 5; yourself.
	a1 lst add: (MTTestObjectA new lint: 6; yourself).
	a1 lst add: (MTTestObjectA new lint: 6; yourself).
	a1 lst add: (MTTestObjectA new lint: 3; yourself).
		
	result := matcher match: {1. 6. a1}. 
	self assert: result isMatch.
	self assert: result matchingContexts size equals: 2.
	
	bindings := result bindingsFor: #z.
	self assert: bindings size equals: 2.
	self assert: (bindings at: 1) ~= (bindings at: 2).
	self assert: (bindings at: 1) lint equals: ((result bindingsFor: #x) at: 1).

]

{ #category : 'tests - to be refined' }
MatcherCollectionTests >> testListWildcardWithInnerMatcher4 [

	| matcher result |
	matcher := { 
		#'*l1'.
	} asMatcher.
		
	result := matcher match: #(1 6 #'7'). 
	self assert: result isMatch.
	self assert: result matchingContexts size equals: 1

]

{ #category : 'tests - to be refined' }
MatcherCollectionTests >> testListWildcardWithInnerMatcher5 [

	| matcher result |
	matcher := { 
		#'*l1'.
		#'7'
	} asMatcher.
		
	result := matcher match: #(1 6 #'7'). 
	self assert: result isMatch.
	self assert: result matchingContexts size equals: 1

]

{ #category : 'tests - to be refined' }
MatcherCollectionTests >> testListWildcardsOnly [

	| matcher result |
	matcher := { #'*l1'. #'*l2' } asMatcher.
	
	result := matcher match: #(10 20 30 30 40 50).
	
	self assert: result isMatch.  
	self assert: result matchingContexts size equals: 7
]

{ #category : 'tests' }
MatcherCollectionTests >> testListWildcardsinList [

	| pattern result bindingKeys|
	pattern := { #'@x'. #'*_'. #'@x'. #'*_' }.

	result := pattern match: #( 1 2 3 1 2 ).
	self assert: result isMatch.
	
	bindingKeys := result matchingContexts flatCollect: [ :each | each bindings keys ].
	self assert: bindingKeys equals:  {#x} asOrderedCollection  .
]

{ #category : 'tests' }
MatcherCollectionTests >> testLiteralNodeInCollection [

	| matcher expression |
	"Here we are trying to check if selector '#ifTrue:ifFalse:' exists with dedicated arguments and receiver"
	expression := RBParser parseExpression: '[ 1 ]'.
	matcher := RBBlockNode
	           % { (#statements <=> RBLiteralNode %% { (#value <=> 1) }) }.

	self assert: (matcher match: expression) isMatch.
	"The expression is correct as we defined correctly the structure of the matcher, and at the end we precised that we want value 1 inside the blockNode followed by anything. "


]

{ #category : 'tests - to be refined' }
MatcherCollectionTests >> testMultiWildcardsAndMultiItemsComplex [

	| matcher expression result | 
	expression := RBParser parseExpression: 'self ifTrue: [1] ifFalse: 2'.
	matcher := RBMessageNode % { 
		           (#'receiver>name' <=> #self).
		           (#'selector>value' <=> #'ifTrue:ifFalse:').
		           (#arguments <=> { 
			            #'@something'. #'@somethingElse' })
					}.

	result := matcher match: expression.
	self assert: result isMatch.
 	self assert: result matchingContexts size equals: 1.
		
]

{ #category : 'tests - to be refined' }
MatcherCollectionTests >> testSameWildcards [

	| matcher expression result |
	expression := RBParser parseExpression:
		              'a ifTrue: 1 ifFalse: [2]. b ifTrue: 1 ifFalse: [4]. '.

	matcher := RBSequenceNode % { (#statements <=> { 
		            (RBMessageNode % { 
			             (#'receiver>name' <=> #a).
			             (#'selector>value' <=> #ifTrue:ifFalse:).
			             (#arguments <=> { 
				              #'@something'.
				              (RBBlockNode % { (#'statements>value' <=> 2) }) }) }).
		            (RBMessageNode % { 
			             (#'receiver>name' <=> #b).
			             (#'selector>value' <=> #ifTrue:ifFalse:).
			             (#arguments <=> { 
				              #'@something'.
				              (RBBlockNode % { (#'statements>value' <=> 4) }) }) }) }) }.

	result := matcher match: expression.
	self assert: result isMatch.
	self
		assertCollection:
		(matcher collectBinding: #something for: expression)
		hasSameElements: { (RBLiteralNode value: 1) }
]

{ #category : 'tests - to be refined' }
MatcherCollectionTests >> testSequenceEquivalenceForListWildcards [

	| matcher result method |
	method := RBParser parseMethod: 'recmethod 
		true ifTrue: [ false ifTrue: [ self foo. self bar.] ]
			  ifFalse: [ self foo. self bar.].
		[self foo. self bar].
		[self foo. self bar. self baz].'.

	matcher := (RBMethodNode % { (#'children*' <=> { 
		             #'*_'.
		             (RBBlockNode % { (#statements <=> { #'*l1' }) }) as: #first.
		             #'*_'.
		             (RBBlockNode % { (#statements <=> { #'*l1' }) }) as: #second.
		             #'*_' }) }) asMatcher.

	result := matcher match: method.
	self assert: result isMatch.
	self assert: result matchingContexts size equals: 3.
]

{ #category : 'tests - to be refined' }
MatcherCollectionTests >> testSequenceMatchingRepetitions [

	| matcher result list |
	
	list := #(10 10 20 20 30 40 50 50).
	
	matcher :=  { #'*l1'. #'@x'. #'@x'. #'*l2' } asMatcher.
		
	result := matcher match: list. 
	self assert: result isMatch.
	self assert: result matchingContexts size equals: 3.
]

{ #category : 'tests - to be refined' }
MatcherCollectionTests >> testSequenceMatchingRepetitionsNonFollowing [

	| matcher result list |
	
	list := #(10 20 10 20 30 30 40).
	
	matcher :=  { #'*l1'. #'@x'. #'*l2'. #'@x'. #'*l3' } asMatcher.
		
	result := matcher match: list. 
	self assert: result isMatch.
	self assert: result matchingContexts size equals: 3.
]

{ #category : 'tests - to be refined' }
MatcherCollectionTests >> testSequenceMatchingWithListWildcard [

	| matcher result method |
	
	method := RBParser parseMethod: 'recmethod 
		true ifTrue: [ false ifTrue: [ 1. 
				                         2. 
				                         self halt. 
				                         self recmethod.
				                         3. ] ]
			  ifFalse: [ self halt. 
				          self recmethod. 
				          1. 
				          2.
				          self halt.
							 self recmethod]'.
	
	matcher := (RBMethodNode % {
		#selector <=> #'@methodName'.
		#'children*' <=> (RBBlockNode % { 
			#statements <=> { #'*l1'.
								 RBMessageNode % {
									#'selector>value' <=> #halt.
									#'receiver>name' <=> #self
							 	} as: #HALT.
								RBMessageNode % {
									#'selector>value' <=> #'@methodName'.
									#'receiver>name' <=> #self.
								} as: #REC.
								#'*l2'
			} 
		} ) 
	}) asMatcher.
		
	result := matcher match: method. 
	self assert: result isMatch.
	self assert: (result bindingsFor: #REC) size equals: 1.
	self assert: (result bindingsFor: #HALT) size equals: 1.
	self assert: ((result bindingsFor: #REC) at: 1) receiver name equals: #self.
	self assert: ((result bindingsFor: #REC) at: 1) selector value equals: #recmethod.

]

{ #category : 'tests - to be refined' }
MatcherCollectionTests >> testShouldNotMatchMissingItem [

	| matcher expression |
	expression := RBParser parseExpression:
		              'a asStringOn: aStream delimiter: delimString last: lastDelimString'.

	matcher := RBMessageNode % { (#children <=> { 
		            (RBVariableNode % { (#value <=> 'a') }).
		            #'@something'.
		            (RBVariableNode % { (#value <=> 'delimString') }) }) }.

	self assert: (matcher match: expression) isMatch not 
]

{ #category : 'tests - to be refined' }
MatcherCollectionTests >> testShouldNotMatchMissingWieldcard [

	| matcher expression |
	expression := RBParser parseExpression:
		              'a asStringOn: aStream delimiter: delimString last: lastDelimString'.

	matcher := RBMessageNode % { (#children <=> { 
		            (RBVariableNode % { (#value <=> 'a') }).
		            (RBVariableNode % { (#value <=> 'aStream') }). 
		            (RBVariableNode % { (#value <=> 'lastDelimString') }) }) }.

	self assert: (matcher match: expression) isMatch not
]

{ #category : 'tests - to be refined' }
MatcherCollectionTests >> testSimpleIntegerCollection [

	| matcher |
	matcher := { 1. 2. 3. 4. 5 } asMatcher.

	self assert: (matcher match: #( 1 2 3 4 5 )) isMatch
]

{ #category : 'tests' }
MatcherCollectionTests >> testToCheckDedicatedArgumentsAndReceiver [

	| matcher expression |
	"Here we are trying to check if selector '#ifTrue:ifFalse:' exists with dedicated arguments and receiver"
	expression := RBParser parseExpression: 'self ifTrue: [1] ifFalse: 2'.
	matcher := RBMessageNode % { 
		           (#'receiver>name' <=> #self).
		           (#'selector>value' <=> #'ifTrue:ifFalse').
		           (#arguments <=> { 
			            (RBBlockNode % { 
								(#statements <=> RBLiteralNode %% { (#value <=> 1) }) 
							}). "first argument"
			            #'@something' }) "second argument" }.

	self assert: (matcher match: expression) isMatch.
	"The expression is correct as we defined correctly the structure of the matcher, and at the end we precised that we want value 1 inside the blockNode followed by anything. "

	self
		assertCollection:
		(matcher collectBinding: #something for: expression)
		hasSameElements: { (RBLiteralNode value: 2) }

	"Here we are checking if @something could match with 2"
]

{ #category : 'tests' }
MatcherCollectionTests >> testToCheckDedicatedArgumentsAndReceiverAreNotMatching [

	| matcher expression |
	"Here we defined a matcher that is missing a variableNode inside #ifTrue:ifFalse: selector, which is why it is not matching. We should say at least that arguments contain something else or we could be more specific by defining the exact valueas it is in the expression."
	expression := RBParser parseExpression: 'self ifTrue: [1] ifFalse: 2'.

	matcher := RBMessageNode % { 
		           (#'receiver>name' <=> #self).
		           (#'selector>value' <=> #'ifTrue:ifFalse').
		           (#arguments
		            <=> { (RBBlockNode % { (#'statements>value' <=> 1) }) }) }.

	self assert: (matcher match: expression) isMatch not
]

{ #category : 'tests' }
MatcherCollectionTests >> testToCheckDedicatedArgumentsAndReceiverWithDirectPath [

	| matcher expression |
	"Here we are trying to check if selector '#ifTrue:ifFalse:' exists with dedicated arguments and receiver; But instead of specifying that RBBlockNode  should have the first value 1, it could match if ifFalse also has a block of 1.  "
	expression := RBParser parseExpression: 'self ifTrue: [1] ifFalse: 2'.

	matcher := RBMessageNode % { 
		           (#'receiver>name' <=> #self).
		           (#'selector>value' <=> #'ifTrue:ifFalse:').
		           (#arguments <=> { 
			            (RBBlockNode % { (#'statements>value' <=> 1) }).
			            #'@something' }) }.

	self assert: (matcher match: expression) isMatch.
	self
		assertCollection:
		(matcher collectBinding: #something for: expression)
		hasSameElements: { (RBLiteralNode value: 2) }
]

{ #category : 'tests' }
MatcherCollectionTests >> testVariableWildcardsinList [

	| pattern result bindingKeys|
	pattern := { #'@x'. #'@_'. #'@x'. #'@_' }.

	result := pattern match: #( 1 2 1 ). 
	self deny: result isMatch.
	
	result := pattern match: #( 1 2 1 2 ). 
	self assert: result isMatch.
	
	bindingKeys := result matchingContexts flatCollect: [ :each | each bindings keys ].
	self assert: bindingKeys equals:  {#x} asOrderedCollection  .
]

{ #category : 'tests - to be refined' }
MatcherCollectionTests >> testWildcardIsAnonymous [

	| matcher |
	matcher := #'*_' asMatcher.

	self assert: matcher isAnonymous
]

{ #category : 'tests - to be refined' }
MatcherCollectionTests >> testWildcardOnly [

	| matcher expression |
	expression := RBParser parseExpression:
		              'a asStringOn: aStream delimiter: delimString last: lastDelimString'.
	matcher := RBMessageNode % { (#children <=> #'@something') }.

	self assert: (matcher match: expression) isMatch.

	"Not sure how to test this"
	"self
		assertCollection:
		(matcher collectBinding: #something for: expression)
		hasSameElements: { (RBVariableNode value: 'a') }"
]

{ #category : 'tests - to be refined' }
MatcherCollectionTests >> testWildcardSameAsItem [

	| matcher expression |
	expression := RBParser parseExpression:
		              'a asStringOn: aStream delimiter: delimString last: delimString'.

	matcher := RBMessageNode % { (#children <=> { 
		            (RBVariableNode % { (#name <=> 'a') }).
		            (RBVariableNode % { (#name <=> 'aStream') }).
		            #'@something'.
		            (RBVariableNode % { (#name <=> 'delimString') }) }) }.

	self assert: (matcher match: expression) isMatch
]

{ #category : 'tests - to be refined' }
MatcherCollectionTests >> testWildcardWithMultiItemsAtTheBegining [

	| matcher expression |
	expression := RBParser parseExpression:
		              'a asStringOn: aStream delimiter: delimString last: lastDelimString'.
	matcher := RBMessageNode % { (#arguments <=> { 
		            (RBVariableNode % { (#name <=> 'aStream') }).
		            #'@something'.
		            #'@somethingElse' }) }.

	self assert: (matcher match: expression) isMatch
]

{ #category : 'tests - to be refined' }
MatcherCollectionTests >> testWildcardWithMultiItemsAtTheEnd [

	| matcher expression |
	expression := RBParser parseExpression:
		              'a asStringOn: aStream delimiter: delimString last: lastDelimString'.
	matcher := RBMessageNode % { (#arguments <=> { 
						#'@something'.
						#'@somethingElse'.
		            (RBVariableNode % { (#name <=> 'lastDelimString') }) }) }.

	self assert: (matcher match: expression) isMatch
]

{ #category : 'tests - to be refined' }
MatcherCollectionTests >> testWildcardWithOneItemAtTheBegining [

	| matcher expression |
	expression := RBParser parseExpression: 'a ifTrue:[1] ifFalse:2'.
	matcher := RBMessageNode % { (#arguments <=> { 
		            (RBBlockNode
		             %
		             { (#statements <=> RBLiteralNode %% { (#value <=> 1) }) }).
		            #'@something' }) }.

	self assert: (matcher match: expression) isMatch.

	self
		assertCollection:
		(matcher collectBinding: #something for: expression)
		hasSameElements: { (RBLiteralNode value: 2) }
]

{ #category : 'tests - to be refined' }
MatcherCollectionTests >> testWildcardWithOneItemAtTheEnd [

	| matcher expression |
	expression := RBParser parseExpression: 'a ifTrue:1 ifFalse:[2]'.
	matcher := RBMessageNode % { (#arguments <=> { 
		            #'@something'.
		            (RBBlockNode
		             %
		             { (#statements <=> RBLiteralNode %% { (#value <=> 2) }) }) }) }.

	self assert: (matcher match: expression) isMatch.

	self
		assertCollection:
		(matcher collectBinding: #something for: expression)
		hasSameElements: { (RBLiteralNode value: 1) }
]
