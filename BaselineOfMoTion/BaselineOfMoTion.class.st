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
            baseline: 'FASTTypeScript'
            with: [
                spec repository: 'github://moosetechnology/FASTTypescript:main' ].

        spec
            package: #MoTion;
            package: #'MoTion-Tests' with: [ spec requires: #( 'MoTion' ) ];
            package: #'MoTion-Moose' with: [ spec requires: #( 'MoTion' ) ];
            package: #'MoTion-FAST-Transformation' with: [ spec requires: #( 'MoTion' 'FASTTypeScript') ];
            package: #'MoTion-FAST-Transformation-Tests' with: [ spec requires: #( 'MoTion-FAST-Transformation' ) ].

        spec group: 'default' with: #( 'MoTion' 'MoTion-Tests' ).
        spec group: 'MoTionMoose' with: #( 'default' 'MoTion-Moose' ).
        spec group: 'MoTionFAST' with: #( 'MoTion-Moose' 'MoTion-FAST-Transformation' 'MoTion-FAST-Transformation-Tests' ) ]
]
