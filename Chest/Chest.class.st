Class {
	#name : #Chest,
	#superclass : #ComposablePresenter,
	#instVars : [
		'playground',
		'list',
		'helpLabel',
		'buttonBar',
		'helpButton',
		'emptyButton'
	],
	#classVars : [
		'contents'
	],
	#category : #Chest
}

{ #category : #API }
Chest class >> add: anObject [
	contents add: anObject.
	self contentsUpdated.
]

{ #category : #API }
Chest class >> at: anIndex [
	^ self contents at: anIndex
]

{ #category : #accessing }
Chest class >> contents [
	^ contents ifNil: [ contents := OrderedCollection new. ^ contents]
]

{ #category : #accessing }
Chest class >> contentsUpdated [
	self allInstancesDo: [ :inst | inst updateList ].
]

{ #category : #'menu-entry' }
Chest class >> debugWorldMenuOn: aBuilder [
	<worldMenu>
	(aBuilder item: #'Open Chest')
		parent: #Debugging;
		order: 0;
		help: '';
		action: [ self open ]
]

{ #category : #specs }
Chest class >> defaultSpec [
	^ SpecPanedLayout newVertical
		add: (SpecPanedLayout newHorizontal
			add: #list;
			add: #playground;
			yourself);
		add: (SpecBoxLayout newHorizontal 
			add: #helpLabel;
			add: #buttonBar;
			yourself)
		
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

{ #category : #API }
Chest class >> empty [
	contents := nil.
	self contentsUpdated.
]

{ #category : #examples }
Chest class >> open [
	<example>
	^ self new openWithSpec
]

{ #category : #API }
Chest class >> remove: anObject [
	contents remove: anObject.
	self contentsUpdated.
]

{ #category : #API }
Chest class >> removeAt: anIndex [
	self contents removeAt: anIndex.
	self contentsUpdated.
]

{ #category : #specs }
Chest class >> title [
	^ 'Chest'
]

{ #category : #initialization }
Chest >> initializeWidgets [
	playground := StPlayground new.
	playground text autoAccept: true.
	list := self newTable.
	list addColumn: (IndexTableColumn title: 'Index');
		addColumn: (StringTableColumn title: 'Object' evaluated: [ :obj | obj asString ]).
	list items: self class contents.
	helpLabel := self newLabel.
	helpLabel label: 'Use Chest to store objects from anywhere'.
	buttonBar := self newButtonBar.
	helpButton := self newButton
"		action: [ UIManager default alert: 'hello' ];"
		action: [ UIManager default confirm: 'Store an object: Chest add: anObject' label: 'Help on Chest' ];
		icon: ((self iconNamed: #help) scaledToSize: 16 @ 16).
		"icon: ((self iconNamed: #question) scaledToSize: 16 @ 16)."
	emptyButton := self newButton
		action: [ Chest empty ];
		icon: ((self iconNamed: #remove) scaledToSize: 16 @ 16).
	buttonBar add: helpButton;
		add: emptyButton.
]

{ #category : #updating }
Chest >> updateList [
	list ifNotNil: [:lst | lst items: self class contents].
]
