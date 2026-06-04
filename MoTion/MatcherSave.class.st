"
Bindings can be created with the `as:` method. It is used to bind the result of a pattern that we call MatcherSave that will be kept in the result’s bindings. It is used to store the result a sub-pattern in a MatcherSave to be retrieved after a match using `#collectBindings:for:` or `#collectBinding:for:`.
"
Class {
	#name : 'MatcherSave',
	#superclass : 'Matcher',
	#instVars : [
		'alias',
		'matcher'
	],
	#category : 'MoTion-matcher',
	#package : 'MoTion',
	#tag : 'matcher'
}

{ #category : 'instance creation' }
MatcherSave class >> of: aMatcher withAlias: aSymbol [

	^ self new
		  matcher: aMatcher;
		  alias: aSymbol;
		  yourself
]

{ #category : 'accessing' }
MatcherSave >> alias: aSymbol [

	alias := aSymbol
]

{ #category : 'accessing' }
MatcherSave >> match: anObject withContext: aContext [

	aContext atBindingKey: alias put: anObject.
	^ matcher match: anObject withContext: aContext
]

{ #category : 'accessing' }
MatcherSave >> matcher [
    ^ matcher
]

{ #category : 'accessing' }
MatcherSave >> matcher: aMatcher [

	matcher := aMatcher
]
