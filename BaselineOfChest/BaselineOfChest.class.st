Class {
	#name : #BaselineOfChest,
	#superclass : #BaselineOf,
	#category : #BaselineOfChest
}

{ #category : #baselines }
BaselineOfChest >> baseline: spec [
	<baseline>
	
	spec for: #common do: [ 
		spec 
			package: 'Chest';
			package: 'Chest-Tests';
			baseline: 'NewTools' with: [
				spec
					repository: 'github://pharo-spec/NewTools/tree/master/src'.
					"repository: 'github://pharo-ide/ClassAnnotation:v0.4.0/src';
					loads: 'Core' "
			]
	]
]
