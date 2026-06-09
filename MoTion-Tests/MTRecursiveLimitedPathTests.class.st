Class {
	#name : 'MTRecursiveLimitedPathTests',
	#superclass : 'MTRecursiveChildrenPathTests',
	#instVars : [
		'd',
		'e',
		'f',
		'g',
		'h'
	],
	#category : 'MoTion-Tests',
	#package : 'MoTion-Tests'
}

{ #category : 'running' }
MTRecursiveLimitedPathTests >> setUp [

	super setUp.
	d := MTTestObjectD new.
	e := MTTestObjectE new.
	f := MTTestObjectF new.
	g := MTTestObjectG new.
	h := MTTestObjectH new.
	d e: e.
	d f: f.
	e g: g.
	f h: h.
	d child: e.
	e child: f.
	f child: g.
	g child: h.
	h child: d.
]

{ #category : 'tests' }
MTRecursiveLimitedPathTests >> testAsObjectPathParsing [
    | path |
    path := #'e*2' asObjectPath.
    self assert: path class equals: MTRecursiveLimitedPath.
]

{ #category : 'tests' }
MTRecursiveLimitedPathTests >> testChild2OnlyFollowsChildSlot [
    | pattern result |
    "F trouvé via child→child (depth 2) ✅"
    pattern := MTTestObjectD
               % { ('child*2' <=> (MTTestObjectF % {} as: #found)) }
               as: #objectD.
    result := pattern match: d.
    self assert: result isMatch equals: true.   "← F trouvé ✅"

    "E trouvé via child (depth 1) ✅"
    pattern := MTTestObjectD
               % { ('child*2' <=> (MTTestObjectE % {} as: #found)) }
               as: #objectD.
    result := pattern match: d.
    self assert: result isMatch equals: true.   "← E trouvé ✅"

    "G PAS trouvé — trop profond pour depth 2"
    pattern := MTTestObjectD
               % { ('child*2' <=> (MTTestObjectG % {} as: #found)) }
               as: #objectD.
    result := pattern match: d.
    self assert: result isMatch equals: false.  "← G pas trouvé ✅"
]

{ #category : 'tests' }
MTRecursiveLimitedPathTests >> testDepth0 [
    | path result |
    path := MTRecursiveLimitedPath of: #e depth: 0.
    result := path resolveFrom: d.
    self assertCollection: result hasSameElements: #().
]

{ #category : 'tests' }
MTRecursiveLimitedPathTests >> testDepth1 [
    | path result |
    path := MTRecursiveLimitedPath of: #e depth: 1.
    result := path resolveFrom: d.
    self assertCollection: result hasSameElements: { e }.
]

{ #category : 'tests' }
MTRecursiveLimitedPathTests >> testDepth1OnF [
    | path result |
    path := MTRecursiveLimitedPath of: #f depth: 1.
    result := path resolveFrom: d.
    self assertCollection: result hasSameElements: { f }.
]

{ #category : 'tests' }
MTRecursiveLimitedPathTests >> testDepth2 [

	| pattern result |
	pattern := MTTestObjectD
	           % { ('e*2' <=> (MTTestObjectE % {  } as: #found)) } as:
		           #objectD.
	result := pattern match: d.
	self assert: result isMatch equals: true
]

{ #category : 'tests' }
MTRecursiveLimitedPathTests >> testDepth2EversG [

	| pattern result |
	pattern := MTTestObjectD
	           % { ('e>g*2' <=> (MTTestObjectG % {  } as: #found)) } as:
		           #objectD.
	result := pattern match: d.
	self assert: result isMatch equals: true
]

{ #category : 'tests' }
MTRecursiveLimitedPathTests >> testDepthWithNonExistentPath [
    | path result |
    path := MTRecursiveLimitedPath of: #z depth: 2.
    result := path resolveFrom: a.
    self assertCollection: result hasSameElements: #().
]

{ #category : 'tests' }
MTRecursiveLimitedPathTests >> testDtoDcomposedPath [

 | pattern result |
 pattern:= MTTestObjectD % { 
     'f>child*2' <=> MTTestObjectH  % {  } as: #childH
 } as: #objectD . 
 result:= pattern match: d .
 self assert: result isMatch equals: true.
]

{ #category : 'tests' }
MTRecursiveLimitedPathTests >> testDtoDcomposedPathIncorrect [

 | pattern result |
 pattern:= MTTestObjectD % { 
     'f>child*2' <=> MTTestObjectH  % {  } as: #childH
 } as: #objectD . 
 result:= pattern match: d .
 self assert: result isMatch equals: true.
]

{ #category : 'tests' }
MTRecursiveLimitedPathTests >> testDtoF [

	| pattern result |
	pattern := MTTestObjectD
	           % { ('child*2' <=> MTTestObjectF % {  } as: #childF) }
		           as: #objectD.
	result := pattern match: d.
	self assert: result isMatch equals: true
]

{ #category : 'tests' }
MTRecursiveLimitedPathTests >> testDtoFIncorrect [

	| pattern result |
	pattern := MTTestObjectD
	           % { ('child*3' <=> MTTestObjectF % {  } as: #childF) }
		           as: #objectD.
	result := pattern match: d.
	self deny: result isMatch
]

{ #category : 'tests' }
MTRecursiveLimitedPathTests >> testDtoFsevenTimes [
	"normalment c doit etre correct"

	| pattern result |
	pattern := MTTestObjectD
	           % { ('child*7' <=> MTTestObjectF % {  } as: #childF) }
		           as: #objectD.
	result := pattern match: d.
	self assert: result isMatch equals: true
]

{ #category : 'tests' }
MTRecursiveLimitedPathTests >> testDtoFsevenTimesIncorrect [

	| pattern result |
	pattern := MTTestObjectD
	           % { ('child*7' <=> MTTestObjectF % {  } as: #childF) }
		           as: #objectD.
	result := pattern match: d.
	self assert: result isMatch equals: true
]

{ #category : 'tests' }
MTRecursiveLimitedPathTests >> testDtoGsevenTimesIncorrect [

	| pattern result |
	pattern := MTTestObjectD
	           % { ('child*8' <=> MTTestObjectG % {  } as: #childF) }
		           as: #objectD.
	result := pattern match: d.
	self assert: result isMatch equals: true
]

{ #category : 'tests' }
MTRecursiveLimitedPathTests >> testDtoHcomposedPath [

	| pattern result |
	pattern := MTTestObjectD
	           % { ('f>child*2' <=> MTTestObjectH % {  } as: #childH) }
		           as: #objectD.
	result := pattern match: d.
	self assert: result isMatch equals: true
]

{ #category : 'tests' }
MTRecursiveLimitedPathTests >> testEToChild [

	| pattern result |
	pattern := MTTestObjectD
	           % { (#'e>child' <=> MTTestObjectF % {  } as: #childF) }
		           as: #objectD.
	result := pattern match: d.
	self assert: result isMatch equals: true
]

{ #category : 'tests' }
MTRecursiveLimitedPathTests >> testEToHwithSupSymbol [

	| pattern result |
	pattern := MTTestObjectD
	           % { (#'e>child*3' <=> MTTestObjectH % {  } as: #foundH) }
		           as: #objectH.
	result := pattern match: d.
	self assert: result isMatch equals: true
]

{ #category : 'tests' }
MTRecursiveLimitedPathTests >> testEtoDWildcardIncorrect [

	| pattern result |
	pattern := MTTestObjectE
	           % { ('_*2' <=> MTTestObjectD % {  } as: #childD) } as:
		           #objectE.
	result := pattern match: e.
	self deny: result isMatch equals: true
]

{ #category : 'tests' }
MTRecursiveLimitedPathTests >> testEtoDWildcardIncorrects [

	| pattern result |
	pattern := MTTestObjectE
	           % { ('_*2' <=> MTTestObjectD % {  } as: #childD) } as:
		           #objectE.
	result := pattern match: e.
	self deny: result isMatch equals: true
]

{ #category : 'tests' }
MTRecursiveLimitedPathTests >> testEtoGWildcardCorrect [

 | pattern result |
 pattern:= MTTestObjectE % { 
     '_*2' <=> MTTestObjectH  % {  } as: #childH
 } as: #objectE . 
 result:= pattern match: e .
 self assert: result isMatch equals: true.
]

{ #category : 'tests' }
MTRecursiveLimitedPathTests >> testFtoDreversed [
	| pattern result |
	pattern := MTTestObjectF 
	           % { ('child*3' <=> MTTestObjectD % {  } as: #childD) }
		           as: #objectD.
	result := pattern match: f.
	self assert: result isMatch equals: true
]

{ #category : 'tests' }
MTRecursiveLimitedPathTests >> testNegation [

	| pattern result |
	"Trouve D qui n'a PAS f = G"
	pattern := MTTestObjectD % { (#f <~=> MTTestObjectG % {  }) }.
	result := pattern match: d.
	self assert: result isMatch
]

{ #category : 'tests' }
MTRecursiveLimitedPathTests >> testNonLinear [

	| pattern result |
	"Trouve D où e et child pointent vers le même objet"
	pattern := MTTestObjectD % {
		           (#e <=> #'@same').
		           (#child <=> #'@same') }.
	result := pattern match: d.
	self assert: result isMatch
]

{ #category : 'tests' }
MTRecursiveLimitedPathTests >> testOrMatches [

	| pattern result |
	"Trouve D où child est E ou F"
	pattern := MTTestObjectD
	           %
	           { #child
	            <=>
	            (MTTestObjectE % {  } orMatches: MTTestObjectF % {  }) }.
	result := pattern match: d.
	self assert: result isMatch
]

{ #category : 'tests' }
MTRecursiveLimitedPathTests >> testOrMatchesDtoEandF [

	| pattern result |
	"Trouve D où child est E ou F"
	pattern := MTTestObjectD
	           %
	           { (#child
	            <=>
	            (MTTestObjectE % {  } orMatches: MTTestObjectF % {  })) }.
	result := pattern match: d.
	self assert: result isMatch
]

{ #category : 'tests' }
MTRecursiveLimitedPathTests >> testRecursiveLimitedPathDSL [
    | pattern results |
    pattern := MTTestObjectA % {
        #'c*2' <=> (MTTestObjectC % {} as: #found)
    }.
    results := pattern collectBindings: {#found} for: a.
    self assert: results isEmpty not.
]

{ #category : 'tests' }
MTRecursiveLimitedPathTests >> testRecursiveLimitedPathDSLWithPharoAST [
    | pattern result |
    pattern := RBMethodNode % {
        #'children*3' <=> (RBMessageNode % {
            #'selector>value' <=> #>
        } as: #found)
    }.
    result := pattern collectBindings: {#found} 
              for: (MatcherHigherThan >> #matchOnlyNumber:withContext:) ast.
    self assert: result isEmpty not.
]

{ #category : 'tests' }
MTRecursiveLimitedPathTests >> testRecursiveLimitedPathWithObjects [
    | pattern results |
    pattern := MTTestObjectA % {
        #'b>c' <=> (MTTestObjectC % {} as: #found)
    }.
    
    results := pattern collectBindings: {#found} for: a.
    
    self assert: results size equals: 1.
    self assert: (results first at: #found) equals: c.
]

{ #category : 'tests' }
MTRecursiveLimitedPathTests >> testRecursiveLimitedPathWithPharoAST [
    | pattern result |
    "AST of matchOnlyNumber:withContext: contains a > message"
    pattern := RBMethodNode % {
        #'children*3' <=> (RBMessageNode % {
            #'selector>value' <=> #>
        } as: #found)
    }.
    
    result := pattern collectBindings: {#found} 
              for: (MatcherHigherThan >> #matchOnlyNumber:withContext:) ast.
    
    self assert: result isEmpty not.
]

{ #category : 'tests' }
MTRecursiveLimitedPathTests >> testRecursiveLimitedPathWithPharoASTNoLimit [
    | pattern result |
    "AST of matchOnlyNumber:withContext: contains a > message"
    pattern := RBMethodNode % { (#'children*'
                <=>
                (RBMessageNode % { (#'selector>value' <=> #>) } as:
                     #found)) }.
    result := pattern
                  collectBindings: { #found }
                  for:
                  (MatcherHigherThan >> #matchOnlyNumber:withContext:) ast.
    self assert: result isEmpty not.
]

{ #category : 'tests' }
MTRecursiveLimitedPathTests >> testRecursivePath2 [
| d e f g h path result |
d := MTTestObjectD new.
e := MTTestObjectE new.
f := MTTestObjectF new.
g := MTTestObjectG new.
h := MTTestObjectH new.
d e: e.
d f: f.
e g: g.
f h: h.
"depth 1 → seulement e"
path := MTRecursiveLimitedPath of: #e depth: 1.
result := path resolveFrom: d.
"attendu : { e }"

"depth 2 → e puis g"
path := MTRecursiveLimitedPath of: #e depth: 2.
result := path resolveFrom: d.
"attendu : { e. g }"
]
