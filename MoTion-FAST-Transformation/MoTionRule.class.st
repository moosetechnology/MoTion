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
MoTionRule >> executeOnFirst [
    | matches node newSource newModel |
    matches := self sourcePattern
        collectBindings: { self binding asSymbol }
        for: self model.
    
    "Prend seulement le PREMIER match"
    node := matches first at: self binding asSymbol.
    
    newSource := source
        copyReplaceFrom: node startPos
        to: node endPos
        with: newValue.
    
    newModel := FASTTypeScriptParser new parse: newSource.
    ^ Association key: newSource value: newModel
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
MoTionRule >> executeWithBindings [
    | matches sortedChanges newSource |
    matches := self sourcePattern
                   collectBindings: bindings keys asArray
                   for: self model.
    sortedChanges := OrderedCollection new.
    matches do: [ :match |
        bindings keysAndValuesDo: [ :bindingKey :newVal |
            | nodeOrValue |
            nodeOrValue := match at: bindingKey ifAbsent: [ nil ].
            nodeOrValue isNil ifFalse: [
                (nodeOrValue respondsTo: #startPos)
                    ifTrue: [
                        "cas 1 : nœud AST direct (as:)"
                        (sortedChanges noneSatisfy: [:a | a key startPos = nodeOrValue startPos])
                            ifTrue: [ sortedChanges add: (Association key: nodeOrValue value: newVal) ] ]
                    ifFalse: [
                        (nodeOrValue isKindOf: Collection)
                            ifTrue: [
                                "cas 2 : collection (*rest)"
                                nodeOrValue do: [:each |
                                    | eachNode |
                                    eachNode := (each respondsTo: #startPos)
                                        ifTrue: [ each ]
                                        ifFalse: [ self findNodeWithSourceCode: each inModel: self model ].
                                    (eachNode notNil and: [
                                       "Deduplication pour èviter les memes matchs comme CalculatorNew " sortedChanges noneSatisfy: [:a | a key startPos = eachNode startPos]
                                    ]) ifTrue: [
                                        sortedChanges add: (Association key: eachNode value: newVal) ] ] ]
                            ifFalse: [
                                "cas 3 : String (@x)"
                                | node |
                                node := self findNodeWithSourceCode: nodeOrValue inModel: self model.
                                (node notNil and: [
                                    sortedChanges noneSatisfy: [:a | a key startPos = node startPos]
                                ]) ifTrue: [
                                    sortedChanges add: (Association key: node value: newVal) ] ] ] ] ] ].
    sortedChanges := sortedChanges asSortedCollection: [ :a :b |
                         a key startPos > b key startPos ].
    newSource := source.
    sortedChanges do: [ :assoc |
        | node newVal |
        node := assoc key.
        newVal := assoc value.
        newSource := newSource
                         copyReplaceFrom: node startPos
                         to: node endPos
                         with: newVal ].
    ^ newSource
]

{ #category : 'as yet unclassified' }
MoTionRule >> findAssociation: association in: myPattern [

	myPattern properties do: [ :assoc |
		assoc = association
			ifTrue: [ ^ myPattern ]
			ifFalse: [^ self findAssociation: association in: assoc value ] ]
]

{ #category : 'as yet unclassified' }
MoTionRule >> findNodeWithSourceCode: aString inModel: aModel [


	^ aModel allChildren
		  detect: [ :node |
			  (node respondsTo: #sourceCode) and: [ node sourceCode = aString ] ]
		  ifNone: [ nil ]
]

{ #category : 'as yet unclassified' }
MoTionRule >> findWildcard: aWildcardKey in: anObjectOfTypeA [
	"Recursively searches through associations for the value matching aWildcardKey.
     Returns the value found, or nil if not found."

	anObjectOfTypeA properties do: [ :assoc |
		(assoc value isKindOf: MatcherWildcard) ifTrue: [
			assoc value alias = aWildcardKey ifTrue: [ ^ assoc  ] ].

		"If the value is itself of type A, recurse into it"
		(assoc value isKindOf: MatcherMooseObject) ifTrue: [
			| result |
			result := self findWildcard: aWildcardKey in: assoc value.
			result ifNotNil: [ ^ result ] ] ].

	^ nil
]

{ #category : 'accessing' }
MoTionRule >> model [

	^ model
]

{ #category : 'accessing' }
MoTionRule >> model: anObject [

	model := anObject
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
