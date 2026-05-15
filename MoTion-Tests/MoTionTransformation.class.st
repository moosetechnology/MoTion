Class {
	#name : 'MoTionTransformation',
	#superclass : 'TestCase',
	#instVars : [
		'parser'
	],
	#category : 'MoTion-Tests',
	#package : 'MoTion-Tests'
}

{ #category : 'running' }
MoTionTransformation >> setUp [

	parser := FASTTypeScriptParser new
]

{ #category : 'tests' }
MoTionTransformation >> testAddValueToArray [

    | parser source res pattern results array insertPos |

    parser := FASTTypeScriptParser new.

    source := 'const arr = [1, 2, 3];'.

    res := parser parse: source.

    pattern := FASTTypeScriptArray as: #foundArray.

    results := pattern
        collectBindings: { #foundArray }
        for: (res allWithType: FASTTypeScriptArray) first.

    array := results first at: #foundArray.

    "position avant le ]"
    insertPos := array endPos - 1.

    source := source
        copyReplaceFrom: insertPos
        to: insertPos - 1
        with: ', 4'.

    self assert: (source includesSubstring: '[1, 2, 3, 4]').
]

{ #category : 'tests' }
MoTionTransformation >> testRenameDefinitionOnly [
    | parser source res pattern results method result |
    parser := FASTTypeScriptParser new.
    source := 'class MyClass {
        method1() { }
    }
    class OtherClass {
        method1() { }
        test() {
            let obj = new MyClass();
            obj.method1();
        }
    }'.
    res := parser parse: source.

    "MoTion — trouve la définition dans MyClass seulement"
    pattern := FASTTypeScriptClassDeclaration % {
        (#'children*' <=> (FASTTypeScriptMethodDefinition % {
            (#'name>sourceCode' <=> 'method1')
        } as: #foundMethod))
    }.

    results := pattern
        collectBindings: { #foundMethod }
        for: (res allWithType: FASTTypeScriptClassDeclaration) first.

    method := results first at: #foundMethod.

    "Remplace seulement le nom de la définition"
    result := source
        copyReplaceFrom: method name startPos
        to: method name endPos
        with: 'myMethod1'.

    self assert: (result includesSubstring: 'myMethod1').
    self assert: (result includesSubstring: 'obj.method1').
]

{ #category : 'tests' }
MoTionTransformation >> testRenommerMethode [

	| parser source res pattern results method result |
	parser := FASTTypeScriptParser new.
	source := 'class MyClass {
        method1() { }
        method2() {  }
    }
    class OtherClass {
        method1() { }
        test() {
            let obj = new MyClass();
            obj.method1();
        }
    }'.
	res := parser parse: source.

	"MoTion — trouve la définition dans MyClass seulement"
	pattern := FASTTypeScriptClassDeclaration
	           % { (#'children*' <=> (FASTTypeScriptMethodDefinition
		             % { (#'name>sourceCode' <=> 'method1') } as:
			             #foundMethod)) }.

	results := pattern
		           collectBindings: { #foundMethod }
		           for:
		           (res allWithType: FASTTypeScriptClassDeclaration) first.

	method := results first at: #foundMethod.

	result := source
		          copyReplaceAll: method name sourceCode
		          with: 'myMethod1'.

	self assert: (result includesSubstring: 'myMethod1').
	self deny: (result includesSubstring: 'method1').
	self assert: (result includesSubstring: 'method2')
]

{ #category : 'tests' }
MoTionTransformation >> testReplaceNumberValue [
    | parser source res pattern results number |
    parser := FASTTypeScriptParser new.
    source := 'class MyClass {
    myMethod() {
        let x: number = 3;
    }
}'.
    res := parser parse: source.

    pattern := FASTTypeScriptNumber % {
        (#sourceCode <=> '3')
    } as: #foundNumber.

    results := pattern
        collectBindings: { #foundNumber }
        for: (res allWithType: FASTTypeScriptNumber) first.

    number := results first at: #foundNumber.

    source := source
        copyReplaceFrom: number startPos
        to: number endPos
        with: '5'.

    self assert: (source includesSubstring: '= 5').
    self deny: (source includesSubstring: '= 3').
]

{ #category : 'tests' }
MoTionTransformation >> testReplaceStringValue [
    | parser source res pattern results fragment result |
    parser := FASTTypeScriptParser new.
    source := 'const variable = ''amed'';'.
    res := parser parse: source.

    pattern := FASTTypeScriptStringFragment % {
        (#sourceCode <=> 'amed')
    } as: #foundString.

    results := pattern
        collectBindings: { #foundString }
        for: (res allWithType: FASTTypeScriptStringFragment) first.

    fragment := results first at: #foundString.

    result := source
        copyReplaceFrom: fragment startPos
        to: fragment endPos
        with: 'ahmed'.

    self assert: (result includesSubstring: 'ahmed').
    self deny: (result includesSubstring: '''amed''').
]

{ #category : 'tests' }
MoTionTransformation >> testTSRenameMethodOperator [
	| parser source res result |
	parser := FASTTypeScriptParser new.
	source := 'class MyClass {
        method1() { }
        method2() { }
       
    }'.
	res := parser parse: source.
	source := TSRenameMethodOperator new
		          oldName: 'method1';
		          newName: 'myMethod1';
		          source: source;
		          applyOn: res.
	self assert: (source includesSubstring: 'myMethod1').
	self deny: (source includesSubstring: 'method1').
	self assert: (source includesSubstring: 'method2') 
]
