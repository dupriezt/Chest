Class {
	#name : #ChestPresenter,
	#superclass : #SpPresenter,
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
ChestPresenter class >> add: anObject [
	"Adds an object to the chest. Returns the index at which it has been added."
	self contents add: anObject.
	self contentsUpdated.
	^ contents size
]

{ #category : #API }
ChestPresenter class >> at: anIndex [
	^ self contents at: anIndex
]

{ #category : #accessing }
ChestPresenter class >> contents [
	^ contents ifNil: [ contents := OrderedCollection new. ^ contents]
]

{ #category : #accessing }
ChestPresenter class >> contentsUpdated [
	self allInstancesDo: [ :inst | inst updateObjectTable ].
]

{ #category : #'menu-entry' }
ChestPresenter class >> debugWorldMenuOn: aBuilder [
	<worldMenu>
	(aBuilder item: #'Open Chest')
		parent: #Debugging;
		order: 0;
		help: 'Store objects from anywhere to keep them around, check equality...';
		action: [ self open ];
		icon: (Smalltalk ui icons iconNamed: #group).
]

{ #category : #specs }
ChestPresenter class >> defaultSpec [
    ^ SpBoxLayout newVertical
        add: (SpPanedLayout newHorizontal
            add: #objectTable;
            add: #playground;
            yourself);
        add: (SpBoxLayout newHorizontal 
            add: #descriptionLabel ;
            add: #helpButton withConstraints: [ :cstr | cstr width: 35 ] ;
				add: #emptyButton withConstraints: [ :cstr | cstr width: 35 ];
            yourself) withConstraints: [:contraint | contraint height: 35];
			yourself.
]

{ #category : #API }
ChestPresenter class >> empty [
	contents := nil.
	self contentsUpdated.
]

{ #category : #specs }
ChestPresenter class >> helpExpandedExtent [
	^ self initialExtent + (0@200)
]

{ #category : #specs }
ChestPresenter class >> helpPanelHeight [
	^ 170
]

{ #category : #specs }
ChestPresenter class >> initialExtent [
	^ 400@300
]

{ #category : #API }
ChestPresenter class >> inspectAt: anIndex [
	^ (self contents at: anIndex) inspect
]

{ #category : #examples }
ChestPresenter class >> open [
	<example>
	| a |
	a := self new openWithSpec.
	a window extent: self initialExtent.
	^ a
]

{ #category : #API }
ChestPresenter class >> remove: anObject [
	contents remove: anObject.
	self contentsUpdated.
]

{ #category : #API }
ChestPresenter class >> removeAt: anIndex [
	self contents removeAt: anIndex.
	self contentsUpdated.
]

{ #category : #specs }
ChestPresenter class >> specLayoutHelpExpanded [
	^ self defaultSpec add: 
		(SpBoxLayout newVertical
			add: (SpBoxLayout newHorizontal
				add: #leftSpacerForHelpTitleLabel;
				add: #helpTitleLabel withConstraints: [:cstr | cstr expand: false];
				add: #rightSpacerForHelpTitleLabel;
				yourself)
			withConstraints: [:cstr | cstr expand: false];
			"add: #helpLabel1;"
			add: #helpText withConstraints: [:cstr | cstr height: 130];
			yourself) withConstraints: [:cstr | cstr expand: false; height: 170];
		yourself.
]

{ #category : #specs }
ChestPresenter class >> title [
	^ 'Chest'
]

{ #category : #accessing }
ChestPresenter >> helpText [
	^ 'Chest add: anObject' asText allBold, TextConstants Tab, TextConstants Tab, TextConstants Tab, ' Stores an object into the Chest' asText, TextConstants CR,
	 'Chest at: anIndex' asText allBold, TextConstants Tab, TextConstants Tab, TextConstants Tab, TextConstants Tab, ' Accesses an object from the Chest', TextConstants CR,
'Chest inspectAt: anIndex' asText allBold, TextConstants Tab, TextConstants Tab, ' Inspects an object from the Chest', TextConstants CR,
	'Chest empty' asText allBold, TextConstants Tab, TextConstants Tab, TextConstants Tab, TextConstants Tab, TextConstants Tab, ' Empties the Chest', TextConstants CR,
	'Chest removeAt: anIndex' asText allBold, TextConstants Tab, TextConstants Tab, ' Remove an object from the Chest', TextConstants CR,
	'Click on an object in the list to access it in the playground'.
]

{ #category : #initialization }
ChestPresenter >> initialize [
	super initialize.
	helpExpanded := false.
]

{ #category : #initialization }
ChestPresenter >> initializeWidgets [
	playground := StPlayground new.
	playground text autoAccept: true.
	objectTable := self makeObjectTable.
	descriptionLabel := self newLabel label: 'Use Chest to store objects from anywhere'.
	helpButton := self makeHelpButton.
	emptyButton := self newButton
		action: [ ChestPresenter empty ];
		icon: ((self iconNamed: #remove) scaledToSize: 16 @ 16);
		yourself.
	helpTitleLabel := self newLabel label: 'Help'; emphasis: #bold.
	leftSpacerForHelpTitleLabel := SpSpacerPresenter new.
	rightSpacerForHelpTitleLabel := SpSpacerPresenter new.
	helpText := self newText enabled: false; text: self helpText.
]

{ #category : #accessing }
ChestPresenter >> insertChestAt: anInteger inPlayground: anStPlayground [
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
ChestPresenter >> makeHelpButton [
	|extent|
	^ self newButton
		action: [
			helpExpanded ifFalse: [
				helpExpanded := true.
				extent := self window window extent.
				self window rebuildWithSpecLayout: self class specLayoutHelpExpanded.
				self window extent: (extent + (0@(self class helpPanelHeight))).
				helpButton state: true.]
			ifTrue: [
				helpExpanded := false.
				extent := self window window extent.
				self window rebuildWithSpecLayout: self class defaultSpec.
				self window extent: (extent - (0@(self class helpPanelHeight))).
"				self window extent: self class initialExtent."
				helpButton state: false]];
		icon: ((self iconNamed: #help) scaledToSize: 16 @ 16).
		"icon: ((self iconNamed: #question) scaledToSize: 16 @ 16)."
]

{ #category : #initialization }
ChestPresenter >> makeObjectTable [
	^self newTable
		addColumn: ((SpIndexTableColumn title: 'Index') width: 40);
		addColumn: (SpStringTableColumn title: 'Object' evaluated: [ :obj | obj asString ]);
		items: self class contents;
		whenSelectionChangedDo: [ :item | self insertChestAt: item selectedIndex inPlayground: playground].
]

{ #category : #updating }
ChestPresenter >> updateObjectTable [
	objectTable ifNotNil: [:lst | lst items: self class contents].
]