Class {
	#name : 'MTRecursiveLimitedPath',
	#superclass : 'MTRecursivePath',
	#instVars : [
		'depth'
	],
	#category : 'MoTion',
	#package : 'MoTion'
}

{ #category : 'as yet unclassified' }
MTRecursiveLimitedPath class >> of: aSymbol depth: anInteger [
    | instance |
    instance := self new.
    instance name: aSymbol.
    instance depth: anInteger.
    ^ instance
]

{ #category : 'accessing' }
MTRecursiveLimitedPath >> depth: anInteger [
    depth := anInteger
]

{ #category : 'as yet unclassified' }
MTRecursiveLimitedPath >> internalResolveChildren: anObject depth: currentDepth [
    | directObjects resultsCollection o |

    currentDepth = 0 ifTrue: [ ^ OrderedCollection new ].

    o := (path resolveFrom: anObject) flattened.

    resultsCollection := (o isCollection and: [
        o isString not and: o isSymbol not ])
        ifFalse: [ { o } ]
        ifTrue: [ o ].

    resultsCollection := resultsCollection select: [ :each |
        each isNotNil ].

    currentDepth = 1 ifTrue: [
        ^ resultsCollection
    ].

    directObjects := OrderedCollection new.

    directObjects addAll: (resultsCollection flatCollect: [ :each |
        self
            internalResolveChildren: each
            depth: currentDepth - 1 ]).

    ^ directObjects
]

{ #category : 'as yet unclassified' }
MTRecursiveLimitedPath >> internalResolveChildren: anObject seen: seenObjects depth: currentDepth [
    | directObjects resultsCollection o |
    currentDepth = 0 ifTrue: [ ^ OrderedCollection new ].
    directObjects := OrderedCollection new.
    o := (path resolveFrom: anObject) flattened.
    resultsCollection := (o isCollection and: [
        o isString not and: o isSymbol not ])
        ifFalse: [ { o } ]
        ifTrue: [ o ].
    resultsCollection := resultsCollection select: [ :each |
        each isNotNil ].
    currentDepth = 1
        ifTrue: [ 
            "seulement ici on collecte — niveau exact atteint"
            directObjects addAll: resultsCollection ]
        ifFalse: [
            directObjects addAll: (resultsCollection flatCollect: [ :each |
                self
                    internalResolveChildren: each
                    seen: seenObjects
                    depth: currentDepth - 1 ]) ].
    ^ directObjects
]

{ #category : 'as yet unclassified' }
MTRecursiveLimitedPath >> internalResolveFrom: anObject seen: seenObjects depth: currentDepth [
    | directObjects resultsCollection o |
    currentDepth = 0 ifTrue: [ ^ OrderedCollection new ].
    directObjects := OrderedCollection new.
    o := (path resolveFrom: anObject) flattened.
    resultsCollection := (o isCollection and: [
                              o isString not and: o isSymbol not ])
                             ifFalse: [ { o } ]
                             ifTrue: [ o ].
    resultsCollection := resultsCollection select: [ :each |
                             each isNotNil and: [
                                 (seenObjects includes: each) not ] ].
    directObjects addAll: resultsCollection.
    seenObjects addAll: resultsCollection.
    currentDepth > 1 ifTrue: [
        directObjects addAll: (resultsCollection flatCollect: [ :each |
                 self
                     internalResolveChildren: each
                     seen: seenObjects
                     depth: currentDepth - 1 ]) ].
    ^ directObjects
]

{ #category : 'resolving' }
MTRecursiveLimitedPath >> resolveFrom: anObject [
    ^ (self internalResolveFrom: anObject seen: IdentitySet new depth: depth) asArray
]
