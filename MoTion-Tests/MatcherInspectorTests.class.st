Class {
	#name : 'MatcherInspectorTests',
	#superclass : 'MatcherTests',
	#category : 'MoTion-Tests-matchers',
	#package : 'MoTion-Tests',
	#tag : 'matchers'
}

{ #category : 'tests' }
MatcherInspectorTests >> testComplexPatternConstraintIsNil [

	"testing true match so the inspector "

	| pattern res|
	
	pattern := Package % {
	#'definedClasses>methodDict>ast>allChildren' <=> OCMessageNode % { 
			#'selector>value' <=> #ifTrue:ifFalse:
		}
	}.
	
	res := pattern inspectUsing: (#MoTion asPackage).
	
	self assert:  res originalResult isMatch.
	self assert: res suspiciousConstraint isNil.
		
	

]

{ #category : 'tests' }
MatcherInspectorTests >> testComplexPatternConstraintIsNotNil [
	"Testing an intentional mismatch so the inspector identifies the suspicious constraint."

	| pattern res |
	pattern := Package  % { 
					#'definedClasses>methodDict>ast>allChildren' <=> OCMessageNode % { 
						#'selector>value' <=> #ifTrue:ifFals: 
					} 
				}.

	res := pattern inspectUsing: #MoTion asPackage.
	
	self deny: res originalResult isMatch.
	self assert: res suspiciousConstraint isNotNil.
	self assert: res foundSuspiciousConstraint.
	self assert: res successfulResult isMatch
]

{ #category : 'tests' }
MatcherInspectorTests >> testComplexPatternConstraintIsNotNilWithCollection [
	"Testing an intentional mismatch inside a collection-valued constraint so the inspector identifies the suspicious constraint."

	| node pattern res |
	node := OCParser parseExpression: 'true ifTrue: [ 1 ] ifFalse: [ 2 ]'.
	pattern := OCMessageNode % { 
					#arguments <=> { OCBlockNode % { }. OCLiteralValueNode % {  } } 
				  }.

	res := pattern inspectUsing: node.

	self deny: res originalResult isMatch.
	self assert: res suspiciousConstraint isNotNil.
	self assert: res foundSuspiciousConstraint.
	self assert: res successfulResult isMatch
]

{ #category : 'tests' }
MatcherInspectorTests >> testComplexPatternConstraintIsNotNilWithCollectionAndListWildcard [
	"Testing an intentional mismatch in a collection constraint containing a list wildcard so the inspector identifies the suspicious constraint."

	| node pattern res |
	node := OCParser parseExpression: 'true ifTrue: [ 1 ] ifFalse: [ 2 ]'.
	pattern := OCMessageNode % { 
					#arguments <=> { #'*l1' asMatcher.  OCLiteralValueNode % {  } } 
				  }.

	res := pattern inspectUsing: node.

	self deny: res originalResult isMatch.
	self assert: res suspiciousConstraint isNotNil.
	self assert: res foundSuspiciousConstraint.
	self assert: res successfulResult isMatch
]

{ #category : 'tests' }
MatcherInspectorTests >> testComplexPatternConstraintIsNotNilWithPropertyWildcard [
	"Testing an intentional mismatch under the direct-children property wildcard so the inspector identifies the suspicious constraint."

	| node pattern res |
	node := OCParser parseExpression: 'true ifTrue: [ 1 ] ifFalse: [ 2 ]'.
	pattern := OCMessageNode % { 
						'_' <=> OCLiteralValueNode % { #value <=> 99 } 
				}.

	res := pattern inspectUsing: node.

	self deny: res originalResult isMatch.
	self assert: res suspiciousConstraint isNotNil.
	self assert: res foundSuspiciousConstraint.
	self assert: res successfulResult isMatch
]

{ #category : 'tests' }
MatcherInspectorTests >> testComplexPatternConstraintIsNotNilWithRecursivePropertyWildcard [
	"Testing an intentional mismatch under the recursive-children property wildcard so the inspector identifies the suspicious constraint."

	| node pattern res |
	node := OCParser parseExpression: 'true ifTrue: [ 1 ] ifFalse: [ 2 ]'.
	pattern := OCMessageNode % { 
						'_*' <=> OCLiteralValueNode % { #value <=> 99 } 
				  }.

	res := pattern inspectUsing: node.

	self deny: res originalResult isMatch.
	self assert: res suspiciousConstraint isNotNil.
	self assert: res foundSuspiciousConstraint.
	self assert: res successfulResult isMatch
]

{ #category : 'tests' }
MatcherInspectorTests >> testComplexPatternConstraintIsNotNilWithWildcard [
	"Testing an intentional wildcard conflict so the inspector identifies the suspicious constraint."

	| node pattern res |
	node := OCParser parseExpression: 'true ifTrue: [ 1 ] ifFalse: [ 2 ]'.
	pattern := OCMessageNode % {
		           #'selector>value' <=> #'@same'.
		           #'arguments>size' <=> #'@same'
					}.

	res := pattern inspectUsing: node.

	self deny: res originalResult isMatch.
	self assert: res suspiciousConstraint isNotNil.
	self
		assert: res suspiciousConstraintDescription
		equals: '#''selector>value'' <=> #''@same'''.
	self assert: res foundSuspiciousConstraint.
	self assert: res successfulResult isMatch
]
