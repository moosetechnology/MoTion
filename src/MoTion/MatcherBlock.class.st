Class {
	#name : 'MatcherBlock',
	#superclass : 'MatcherBlockBased',
	#category : 'MoTion-matcher',
	#package : 'MoTion',
	#tag : 'matcher'
}

{ #category : 'accessing' }
MatcherBlock >> match: anObject withContext: aContext [

	| result args |
	"args := block argumentNames allButFirst collect: [ :name | 
		        aContext bindings at: name ].
	result := block valueWithArguments: { anObject }, args asArray."
	args := block argumentNames collect: [ :name | 
		        aContext bindings at: name ].
	result := block valueWithArguments: args asArray.
	^ result asMatcher match: anObject withContext: aContext
]
