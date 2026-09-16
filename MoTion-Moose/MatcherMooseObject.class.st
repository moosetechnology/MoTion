Class {
	#name : 'MatcherMooseObject',
	#superclass : 'MatcherObject',
	#category : 'MoTion-Moose-matcher',
	#package : 'MoTion-Moose',
	#tag : 'matcher'
}

{ #category : 'as yet unclassified' }
MatcherMooseObject class >> type: aClass withProperties: aPropertiesArray [

	| properties |
	properties := aPropertiesArray collect: [ :each | 
		              each key asMooseObjectPath -> each value asMatcher ].
	^ self new
		  type: aClass;
		  properties: properties;
		  yourself
]

{ #category : 'operations' }
MatcherMooseObject >> @ anAlias [
    ^ MatcherSave new
        alias: anAlias;
        matcher: self;
        yourself
]

{ #category : 'testing' }
MatcherMooseObject >> isMooseMatcher [

	^ true
]

{ #category : 'accessing' }
MatcherMooseObject >> properties [
    ^ properties
]

{ #category : 'accessing' }
MatcherMooseObject >> type [
    ^ type
]
