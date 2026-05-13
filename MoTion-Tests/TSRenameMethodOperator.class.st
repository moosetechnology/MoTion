Class {
	#name : 'TSRenameMethodOperator',
	#superclass : 'Object',
	#instVars : [
		'oldName',
		'newName',
		'source'
	],
	#category : 'MoTion-Tests',
	#package : 'MoTion-Tests'
}

{ #category : 'applying' }
TSRenameMethodOperator >> applyOn: aFASTModel [
    | method |
    method := (aFASTModel allWithType: FASTTypeScriptMethodDefinition)
        detect: [ :m | m name sourceCode = oldName ].
    ^ source copyReplaceAll: method name sourceCode with: newName
]

{ #category : 'accessing' }
TSRenameMethodOperator >> newName: aString [
    newName := aString
]

{ #category : 'accessing' }
TSRenameMethodOperator >> oldName: aString [
    oldName := aString
]

{ #category : 'as yet unclassified' }
TSRenameMethodOperator >> renameAll: aFASTModel [
    "définition + toutes les invocations"
    ^ source copyReplaceAll: oldName with: newName.
]

{ #category : 'as yet unclassified' }
TSRenameMethodOperator >> renameDefinitionOnly: aFASTModel [
    | method start end |
    method := (aFASTModel allWithType: FASTTypeScriptMethodDefinition)
        detect: [ :m | m name sourceCode = oldName ].
    start := method name startPos.
    end := method name endPos.
    ^ source copyReplaceFrom: start to: end with: newName.
]

{ #category : 'accessing' }
TSRenameMethodOperator >> source: aString [
    source := aString
]
