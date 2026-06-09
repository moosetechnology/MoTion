Class {
	#name : 'PharoBlockMatcherCompiler',
	#superclass : 'OCProgramNodeVisitor',
	#category : 'MoTion-visitors',
	#package : 'MoTion',
	#tag : 'visitors'
}

{ #category : 'visiting' }
PharoBlockMatcherCompiler >> visitAssignmentNode: assignmentNode [

	| variableMatcher valueMatcher |
	variableMatcher := self visit: assignmentNode variable.
	valueMatcher := self visit: assignmentNode value.

	^ assignmentNode class % { 
		  (#variable <=> variableMatcher).
		  (#value <=> valueMatcher) }
]

{ #category : 'visiting' }
PharoBlockMatcherCompiler >> visitLiteralNode: aLiteralNode [

	^ aLiteralNode class % { 
		#value <=> aLiteralNode value
	}
]

{ #category : 'visiting' }
PharoBlockMatcherCompiler >> visitMessageNode: messageNode [

	| receiverMatcher arguments argumentsMatcher |
	receiverMatcher := self visit: messageNode receiver.

	arguments := messageNode arguments collect: [ :each | 
		             self visit: each ].
	argumentsMatcher := MatcherCollection of: arguments.

	^ messageNode class % { 
		  (#'selector>value' <=> messageNode selector value).
		  (#receiver <=> receiverMatcher).
		  (#arguments <=> argumentsMatcher) }
]

{ #category : 'visiting' }
PharoBlockMatcherCompiler >> visitVariableNode: variableNode [

	(variableNode name beginsWith: #_) ifTrue: [ 
		^ MatcherWildcard of: variableNode name allButFirst 	
	].

	^ variableNode class % { 
		#name <=> variableNode name
	}
]
