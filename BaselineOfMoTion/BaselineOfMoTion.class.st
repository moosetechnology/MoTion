Class {
	#name : 'BaselineOfMoTion',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfMoTion',
	#package : 'BaselineOfMoTion'
}

{ #category : 'baselines' }
BaselineOfMoTion >> baseline: spec [
    <baseline>
    spec for: #common do: [
        spec
            package: #MoTion;
            package: #'MoTion-Tests' with: [ spec requires: #( 'MoTion' ) ];
            package: #'MoTion-Moose' with: [ spec requires: #( 'MoTion' ) ];
            package: 'MoTion-FAST-Transformation' with: [ spec requires: #( 'MoTion' ) ].
        spec group: 'default' with: #( 'MoTion' 'MoTion-Tests' 'MoTion-FAST-Transformation' ).
        spec group: 'MoTionMoose' with: #( 'default' 'MoTion-Moose' ) ]
]
