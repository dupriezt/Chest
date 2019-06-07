Class {
	#name : #Chest,
	#superclass : #ComposablePresenter,
	#instVars : [
		'playground',
		'list',
		'helpLabel',
		'helpButton',
		'emptyButton',
		'helpExpanded',
		'helpLabel1'
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
    ^ SpecBoxLayout newVertical
        add: (SpecPanedLayout newHorizontal
            add: #list;
            add: #playground;
            yourself);
        add: (SpecBoxLayout newHorizontal 
            add: #helpLabel ;
            add: #helpButton withConstraints: [ :cstr | cstr width: 35 ] ;
				add: #emptyButton withConstraints: [ :cstr | cstr width: 35 ];
            yourself) withConstraints: [:contraint | contraint height: 35];
			yourself.
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

{ #category : #'as yet unclassified' }
Chest class >> specLayoutHelpExpanded [
	^ self defaultSpec add: 
		(SpecBoxLayout newVertical
			add: #helpLabel1;
			yourself);
		yourself.
]

{ #category : #specs }
Chest class >> title [
	^ 'Chest'
]

{ #category : #initialization }
Chest >> initialize [
	super initialize.
	helpExpanded := false.
]

{ #category : #initialization }
Chest >> initializeWidgets [
	playground := StPlayground new.
	playground text autoAccept: true.
	list := self newTable
		addColumn: (IndexTableColumn title: 'Index');
		addColumn: (StringTableColumn title: 'Object' evaluated: [ :obj | obj asString ]);
		items: self class contents.
	helpLabel := self newLabel label: 'Use Chest to store objects from anywhere'.
	helpButton := self newButton
		action: [
			helpExpanded ifFalse: [
				helpExpanded := true.
				self window rebuildWithSpecLayout: self class specLayoutHelpExpanded.
				helpButton state: true]
			ifTrue: [
				helpExpanded := false.
				self window rebuildWithSpecLayout: self class defaultSpec.
				helpButton state: false]];
		icon: ((self iconNamed: #help) scaledToSize: 16 @ 16).
		"icon: ((self iconNamed: #question) scaledToSize: 16 @ 16)."
	emptyButton := self newButton
		action: [ Chest empty ];
		icon: ((self iconNamed: #remove) scaledToSize: 16 @ 16).
	helpLabel1 := self newLabel label: 'This is helpful'.
	
]

{ #category : #updating }
Chest >> updateList [
	list ifNotNil: [:lst | lst items: self class contents].
]
