Class {
	#name : #Chest,
	#superclass : #ComposablePresenter,
	#instVars : [
		'playground',
		'helpButton',
		'emptyButton',
		'helpExpanded',
		'descriptionLabel',
		'helpTitleLabel',
		'leftSpacerForHelpTitleLabel',
		'rightSpacerForHelpTitleLabel',
		'helpText',
		'objectTable'
	],
	#classVars : [
		'contents'
	],
	#category : #Chest
}

{ #category : #API }
Chest class >> add: anObject [
	"Adds an object to the chest. Returns the index at which it has been added."
	contents add: anObject.
	self contentsUpdated.
	^ contents size
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
	self allInstancesDo: [ :inst | inst updateObjectTable ].
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
            add: #objectTable;
            add: #playground;
            yourself);
        add: (SpecBoxLayout newHorizontal 
            add: #descriptionLabel ;
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

{ #category : #API }
Chest class >> inspectAt: anIndex [
	^ (self contents at: anIndex) inspect
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
Chest class >> specLayoutHelpExpanded [
	^ self defaultSpec add: 
		(SpecBoxLayout newVertical
			add: (SpecBoxLayout newHorizontal
				add: #leftSpacerForHelpTitleLabel;
				add: #helpTitleLabel withConstraints: [:cstr | cstr expand: false];
				add: #rightSpacerForHelpTitleLabel;
				yourself)
			withConstraints: [:cstr | cstr expand: false];
			"add: #helpLabel1;"
			add: #helpText withConstraints: [:cstr | cstr height: 120];
			yourself) withConstraints: [:cstr | cstr expand: false; height: 110];
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
	objectTable := self newTable
		addColumn: ((IndexTableColumn title: 'Index') width: 40);
		addColumn: (StringTableColumn title: 'Object' evaluated: [ :obj | obj asString ]);
		items: self class contents;
		whenSelectionChangedDo: [ :item | self insertChestAt: item selectedIndex inPlayground: playground].
	descriptionLabel := self newLabel label: 'Use Chest to store objects from anywhere'.
	helpButton := self makeHelpButton.
	emptyButton := self newButton
		action: [ Chest empty ];
		icon: ((self iconNamed: #remove) scaledToSize: 16 @ 16).
	helpTitleLabel := self newLabel label: 'Help'; emphasis: #bold.
	leftSpacerForHelpTitleLabel := SpacerPresenter new.
	rightSpacerForHelpTitleLabel := SpacerPresenter new.
	helpText := self newText enabled: false; text: (
		'Chest add: anObject' asText allBold, TextConstants Tab, ' Stores an object into the Chest' asText, TextConstants CR, 'Chest at: anIndex' asText allBold, TextConstants Tab, TextConstants Tab, ' Accesses an object from the Chest', TextConstants CR, 'Click on an object in the list to access it in the playground').
	
	
	"helpText := self newText enabled: false; text: (Text streamContents: [:stream | stream nextPutAll: {Text string: 'Chest add: anObject' attribute: TextEmphasis bold. 'Stores an object into the chest'}])."
]

{ #category : #accessing }
Chest >> insertChestAt: anInteger inPlayground: anStPlayground [
	| textLeftOfTheSelection textRightOfTheSelection textObject textToAdd selectionStart selectionStop |
	textObject := anStPlayground text.
	selectionStart := textObject getSelection instVarNamed: #start.
	selectionStop := textObject getSelection instVarNamed: #stop.
	textLeftOfTheSelection := textObject text first: selectionStart -1.
	textRightOfTheSelection := textObject text allButFirst: selectionStop.
	textToAdd := '(Chest at: ', anInteger asString, ')'.
	textObject text: (textLeftOfTheSelection, textToAdd, textRightOfTheSelection).
	textObject setSelection: ((textLeftOfTheSelection size + textToAdd size + 1) to: (textLeftOfTheSelection size + textToAdd size)).
	

"playground text text: ((playground text text first: ((playground text getSelection instVarNamed: #start) -1)), '(Chest at: ', item selectedIndex asString, ')',  (playground text text allButFirst:  (playground text getSelection instVarNamed: #stop)))"
]

{ #category : #initialization }
Chest >> makeHelpButton [
	^ self newButton
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
]

{ #category : #updating }
Chest >> updateObjectTable [
	objectTable ifNotNil: [:lst | lst items: self class contents].
]
