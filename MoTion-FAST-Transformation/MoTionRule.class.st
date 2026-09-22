Class {
	#name : 'MoTionRule',
	#superclass : 'Object',
	#instVars : [
		'binding',
		'model',
		'newValue',
		'source',
		'sourcePattern',
		'bindings',
		'removalBindings'
	],
	#category : 'MoTion-FAST-Transformation',
	#package : 'MoTion-FAST-Transformation'
}

{ #category : 'accessing' }
MoTionRule >> binding [

	^ binding
]

{ #category : 'accessing' }
MoTionRule >> binding: anObject [

	binding := anObject
]

{ #category : 'accessing' }
MoTionRule >> bindings [

	^ bindings
]

{ #category : 'accessing' }
MoTionRule >> bindings: anObject [

	bindings := anObject
]

{ #category : 'as yet unclassified' }
MoTionRule >> collectAllBindings [ 

	| results collect |
	
	results := OrderedCollection new.
	collect := nil.
	collect := [:obj |
		(obj isKindOf: MatcherSave) ifTrue: [
			results add: obj.
			collect value: obj matcher ].
		(obj isKindOf: MatcherWildcard) ifTrue: [
			results add: obj ].
		(obj isKindOf: MatcherCollection) ifTrue: [
			results add: obj. ].
		(obj isKindOf: MatcherObject) ifTrue: [
			obj properties do: [:assoc | collect value: assoc value] ] ].
	collect value: sourcePattern .
	^ results
]

{ #category : 'as yet unclassified' }
MoTionRule >> endPosOf: aNodeOrCollection [
	^ (aNodeOrCollection isKindOf: Collection)
		ifTrue: [ (aNodeOrCollection collect: #endPos) max ]
		ifFalse: [ aNodeOrCollection endPos ]
]

{ #category : 'as yet unclassified' }
MoTionRule >> executeRefactorings [
    
	| matches changes newSource | 

	matches := self sourcePattern
		collectBindings: bindings keys asArray
		for: self model.

	changes := OrderedCollection new.

	matches do: [ :eachMatch | 
		bindings keysDo: [ :eachKey |
			| bound |
			bound := eachMatch at: eachKey.
			(bound isKindOf: Collection)
				"ok here we need this condition because perhaps we are matching with WildcardList which returns always a collection of items. so we need to know if that is the case, so we pay attention how to fill the association"
				ifTrue: [
					bound ifNotEmpty: [ 
						changes add: (Association key: bound value: (bindings at: eachKey)) ] ]
				ifFalse: [
					"here I have to check if we have a value or a node. if node continue, if value, check the enclosing param of the binding and match again to find a node and pass it here to create the association. "  
					bound isLiteral 
						ifTrue: [ 
							"in case the match is not a node, then here we rely on the aliasNode captured" 
							changes add: (Association key: (eachMatch at: (eachKey, 'Node') asSymbol) value: (bindings at: eachKey)) ]
						ifFalse: [  
							changes add: (Association key: bound value: (bindings at: eachKey)) ] ] ] ].
	changes := changes asSortedCollection: [ :a :b |
		(self startPosOf: a key) > (self startPosOf: b key) ].

	newSource := source.
	changes do: [ :assoc |
		| newVal |
		newVal := assoc value.
		"ok here we replace values between start and end position. However when there is a collection like * rest, we replace between the min start pos and max endpos"
		newSource := newSource
			copyReplaceFrom: (self startPosOf: assoc key)
			to: (self endPosOf: assoc key)
			with: newVal ].
	^ newSource
]

{ #category : 'as yet unclassified' }
MoTionRule >> executeRemoval [
    | matches sortedNodes newSource |
    matches := self sourcePattern
                   collectBindings: removalBindings
                   for: self model.
    sortedNodes := OrderedCollection new.
    matches do: [ :match |
        removalBindings do: [ :bindingKey |
            | nodeOrValue |
            nodeOrValue := match at: bindingKey ifAbsent: [ nil ].
            nodeOrValue isNil ifFalse: [
                (nodeOrValue respondsTo: #startPos)
                    ifTrue: [ "cas 1 : noeud AST direct (as:)"
                        (sortedNodes noneSatisfy: [ :a |
                            a startPos = nodeOrValue startPos ])
                                ifTrue: [ sortedNodes add: nodeOrValue ] ]
                    ifFalse: [
                        (nodeOrValue isKindOf: Collection)
                            ifTrue: [ "cas 2 : collection (*rest)"
                                nodeOrValue do: [ :each |
                                    | eachNode |
                                    eachNode := (each respondsTo: #startPos)
                                        ifTrue: [ each ]
                                        ifFalse: [
                                            self
                                                findNodeWithSourceCode: each
                                                inModel: self model ].
                                    (eachNode notNil and: [
                                        sortedNodes noneSatisfy: [ :a |
                                            a startPos = eachNode startPos ] ])
                                                ifTrue: [ sortedNodes add: eachNode ] ] ]
                            ifFalse: [ "cas 3 : String (@x)"
                                | node |
                                node := self
                                    findNodeWithSourceCode: nodeOrValue
                                    inModel: self model.
                                (node notNil and: [
                                    sortedNodes noneSatisfy: [ :a |
                                        a startPos = node startPos ] ])
                                            ifTrue: [ sortedNodes add: node ] ] ] ] ] ].
    sortedNodes := sortedNodes asSortedCollection: [ :a :b |
                       a startPos > b startPos ].
    newSource := source.
    sortedNodes do: [ :node |
        | from to |
        from := node startPos.
        to := node endPos.
        "Gère virgule avant"
        ((newSource at: from - 1 ifAbsent: [ nil ]) = $  and: [
             (newSource at: from - 2 ifAbsent: [ nil ]) = $, ])
            ifTrue: [ from := from - 2 ]
            ifFalse: [
                "Gère virgule après"
                (newSource at: to + 1 ifAbsent: [ nil ]) = $,
                    ifTrue: [ to := to + 2 ] ].
        newSource := newSource
                         copyReplaceFrom: from
                         to: to
                         with: '' ].
    ^ newSource
]

{ #category : 'as yet unclassified' }
MoTionRule >> findNodeWithSourceCode: aString inModel: aModel [


	^ aModel allChildren
		  detect: [ :node |
			  (node respondsTo: #sourceCode) and: [ node sourceCode = aString ] ]
		  ifNone: [ nil ]
]

{ #category : 'accessing' }
MoTionRule >> model [

	^ model
]

{ #category : 'accessing' }
MoTionRule >> model: anObject [

	model := anObject.
	source := anObject sourceText.
]

{ #category : 'accessing' }
MoTionRule >> newValue [

	^ newValue
]

{ #category : 'accessing' }
MoTionRule >> newValue: anObject [

	newValue := anObject
]

{ #category : 'accessing' }
MoTionRule >> removalBindings [
    ^ removalBindings
]

{ #category : 'accessing' }
MoTionRule >> removalBindings: aCollection [
    removalBindings := aCollection
]

{ #category : 'accessing' }
MoTionRule >> source [

	^ source
]

{ #category : 'accessing' }
MoTionRule >> source: anObject [

	source := anObject
]

{ #category : 'accessing' }
MoTionRule >> sourcePattern [

	^ sourcePattern
]

{ #category : 'accessing' }
MoTionRule >> sourcePattern: anObject [

	sourcePattern := anObject
]

{ #category : 'as yet unclassified' }
MoTionRule >> startPosOf: aNodeOrCollection [
	^ (aNodeOrCollection isKindOf: Collection)
		ifTrue: [ (aNodeOrCollection collect: #startPos) min ]
		ifFalse: [ aNodeOrCollection startPos ]

]
