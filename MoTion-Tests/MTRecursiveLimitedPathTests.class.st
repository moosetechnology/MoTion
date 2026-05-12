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
]

{ #category : 'tests' }
MTRecursiveLimitedPathTests >> testAsObjectPathParsing [
    | path |
    path := #'e*2' asObjectPath.
    self assert: path class equals: MTRecursiveLimitedPath.
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
    | path result |
    path := MTRecursiveLimitedPath of: #e depth: 2.
    result := path resolveFrom: d.
    self assertCollection: result hasSameElements: { e. g }.
]

{ #category : 'tests' }
MTRecursiveLimitedPathTests >> testDepth2OnF [
    | path result |
    path := MTRecursiveLimitedPath of: #f depth: 2.
    result := path resolveFrom: d.
    self assertCollection: result hasSameElements: { f. h }.
]

{ #category : 'tests' }
MTRecursiveLimitedPathTests >> testDepth3 [
    | path result |
    path := MTRecursiveLimitedPath of: #c depth: 3.
    result := path resolveFrom: a.
    self assertCollection: result hasSameElements: { c. a. b }.
]

{ #category : 'tests' }
MTRecursiveLimitedPathTests >> testDepthWithNonExistentPath [
    | path result |
    path := MTRecursiveLimitedPath of: #z depth: 2.
    result := path resolveFrom: a.
    self assertCollection: result hasSameElements: #().
]

{ #category : 'tests' }
MTRecursiveLimitedPathTests >> testRecursiveLimitedPath [
    | path result |
    
    "depth 1 → seulement c de a"
    path := MTRecursiveLimitedPath of: #c depth: 3.
result := path resolveFrom: a.
self assertCollection: result hasSameElements: { c.  a. b }.
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
