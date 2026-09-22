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
MoTionRule >> enclosingMatcherForAlias: anAlias in: aPattern [
	^ self enclosingMatcherForAlias: anAlias in: aPattern enclosing: nil
]

{ #category : 'as yet unclassified' }
MoTionRule >> enclosingMatcherForAlias: anAlias in: obj enclosing: currentEnclosing [
	(obj isKindOf: MatcherSave) ifTrue: [
		obj alias = anAlias ifTrue: [ ^ obj matcher ].
		^ self enclosingMatcherForAlias: anAlias in: obj matcher enclosing: currentEnclosing ].
	(obj isKindOf: MatcherWildcard) ifTrue: [
		^ (obj alias = anAlias) ifTrue: [ currentEnclosing ] ifFalse: [ nil ] ].
	(obj isKindOf: MatcherCollection) ifTrue: [
		obj matcherSequence do: [:inner |
			| found |
			found := self enclosingMatcherForAlias: anAlias in: inner enclosing: currentEnclosing.
			found ifNotNil: [ ^ found ] ].
		^ nil ].
	(obj isKindOf: MatcherObject) ifTrue: [
		obj properties do: [:assoc |
			| found |
			found := self enclosingMatcherForAlias: anAlias in: assoc value enclosing: obj.
			found ifNotNil: [ ^ found ] ].
		^ nil ].
	^ nil

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
MoTionRule >> executeRefactorings [
    
	| matches sortedChanges changes newSource collectedMatchers| 

	collectedMatchers := self collectAllBindings. 
	
	"1 collect matches and bindings" 
   matches := self sourcePattern
                   collectBindings: bindings keys asArray
                   for: self model.

	changes := OrderedCollection new.
	
	matches do:[ :eachMatch | 
		bindings keysDo: [ :eachKey |
		((eachMatch at: eachKey) respondsTo: #startPos ) ifTrue: [  
			"here I have to check if we have a value or a node. if node continue, if value, check the enclosing param of the binding and match again to find a node and pass it here to create the association. "  
			changes add: (Association key: (eachMatch at: eachKey) value: (bindings at: eachKey)) 
			] ifFalse: [  
 				"in case the match is not a node, then here we rely on the aliasNode captured"
			changes add: (Association key: (eachMatch at: (eachKey, 'Node') ) value: (bindings at: eachKey)) 	
			]. 	
		]. 
	].
		
	"here I have to find for each binding proposed by the developpers, the node that is matched"
	"Then I apply sorting ?? "
	"Then I ask for apply changes"
   
   changes := changes asSortedCollection: [ :a :b |
                         a key startPos > b key startPos ].
   newSource := source.
   changes do: [ :assoc |
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
MoTionRule >> findNode: aNode inModel: aModel [

	^ aModel allChildren
		  detect: [ :node |
			  ((node respondsTo: #sourceCode) and: [ node startPos = aNode startPos ]) and: [ node endPos = aNode endPos ] ]
		  ifNone: [ nil ]
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

{ #category : 'as yet unclassified' }
MoTionRule >> matcher: aMatcher hasAlias: anAlias [
	(aMatcher isKindOf: MatcherSave) ifTrue: [ ^ aMatcher alias = anAlias ].
	(aMatcher isKindOf: MatcherWildcard) ifTrue: [ ^ aMatcher alias = anAlias ].
	^ false
]

{ #category : 'as yet unclassified' }
MoTionRule >> matcherForAlias: anAlias among: collectedMatchers [
	collectedMatchers do: [:matcher |
		(self matcher: matcher hasAlias: anAlias) ifTrue: [ ^ matcher ].
		(matcher isKindOf: MatcherCollection) ifTrue: [
			matcher matcherSequence do: [:inner |
				(self matcher: inner hasAlias: anAlias) ifTrue: [ ^ inner ] ] ] ].
	^ nil

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
