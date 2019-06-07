Class {
	#name : #Chest,
	#superclass : #ComposablePresenter,
	#instVars : [
		'playground',
		'list',
		'helpButton',
		'emptyButton',
		'helpExpanded',
		'helpLabel1',
		'descriptionLabel',
		'helpTitleLabel',
		'leftSpacerForHelpTitleLabel',
		'rightSpacerForHelpTitleLabel',
		'helpText'
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
	list := self newTable
		addColumn: (IndexTableColumn title: 'Index');
		addColumn: (StringTableColumn title: 'Object' evaluated: [ :obj | obj asString ]);
		items: self class contents;
		"whenSelectionChangedDo: [ :item | playground text getSelection inspect]."
		whenSelectionChangedDo: [ :item | self insertChestAt: item selectedIndex inPlayground: playground].
		"whenSelectionChangedDo: [ :item | playground text type: '(Chest at: ', item selectedIndex asString, ')'. ]."
	descriptionLabel := self newLabel label: 'Use Chest to store objects from anywhere'.
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
	helpTitleLabel := self newLabel label: 'Help'; emphasis: #bold.
	leftSpacerForHelpTitleLabel := SpacerPresenter new.
	rightSpacerForHelpTitleLabel := SpacerPresenter new.
	helpText := self newText enabled: false; text: (
		'Chest add: anObject' asText allBold, TextConstants Tab, ' Stores an object into the Chest' asText, TextConstants CR, 'Chest at: anIndex' asText allBold, TextConstants Tab, ' Accesses an object from the Chest', TextConstants CR, 'Click on an object in the list to access it in the playground').
	
	
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
"	textObject setSelection: (1 to: 3)."
	

"playground text text: ((playground text text first: ((playground text getSelection instVarNamed: #start) -1)), '(Chest at: ', item selectedIndex asString, ')',  (playground text text allButFirst:  (playground text getSelection instVarNamed: #stop)))"
]

{ #category : #updating }
Chest >> updateList [
	list ifNotNil: [:lst | lst items: self class contents].
]
