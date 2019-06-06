Class {
	#name : #Chest,
	#superclass : #ComposablePresenter,
	#instVars : [
		'playground',
		'list',
		'helpLabel'
	],
	#classVars : [
		'contents'
	],
	#category : #Chest
}

{ #category : #examples }
Chest class >> add: anObject [
	contents add: anObject.
	self contentsUpdated.
]

{ #category : #examples }
Chest class >> at: anIndex [
	^ self contents at: anIndex
]

{ #category : #accessing }
Chest class >> contents [
	^ contents ifNil: [ contents := OrderedCollection new. ^ contents]
]

{ #category : #'as yet unclassified' }
Chest class >> contentsUpdated [
	self allInstancesDo: [ :inst | inst updateList ].
]

{ #category : #all }
Chest class >> debugWorldMenuOn: aBuilder [
	<worldMenu>
	(aBuilder item: #'Open Chest')
		parent: #Debugging;
		order: 0;
		help: '';
		action: [ self open ]
]

{ #category : #examples }
Chest class >> defaultSpec [
	^ SpecPanedLayout newVertical
		add: (SpecPanedLayout newHorizontal
			add: #list;
			add: #playground;
			yourself);
		add: #helpLabel;
		yourself.
		"add: #menu withConstraints: [ :constraints | constraints height: self toolbarHeight ];"
		"add:
			(SpecPanedLayout newHorizontal
				position: 200;
				add: #list;
				add: #page;
				yourself);
		add: #playground
		yourself"
]

{ #category : #requirements }
Chest class >> empty [
	contents := nil.
	self contentsUpdated.
]

{ #category : #examples }
Chest class >> open [
	<example>
	^ self new openWithSpec
]

{ #category : #examples }
Chest class >> remove: anObject [
	contents remove: anObject.
	self contentsUpdated.
]

{ #category : #removing }
Chest class >> removeAt: anIndex [
	self contents removeAt: anIndex.
	self contentsUpdated.
]

{ #category : #specs }
Chest class >> title [
	^ 'Chest'
]

{ #category : #initialization }
Chest >> initializePresenter [
	
]

{ #category : #initialization }
Chest >> initializeWidgets [
	playground := StPlayground new.
	list := self newTable.
	list addColumn: (IndexTableColumn title: 'Index');
		addColumn: (StringTableColumn title: 'Object' evaluated: [ :obj | obj asString ]).
	list items: self class contents.
	helpLabel := self newLabel.
	helpLabel label: 'Use Chest to store objects from anywhere'.
]

{ #category : #updating }
Chest >> updateList [
	list items: self class contents.
]
