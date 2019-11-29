"
Represent a collection of ChestObject

# Instance Variables
	- contents: OrderedCollection<ChestObject>
		The objects contained in this Chest instance
	- name: String
		Name of this Chest instance
	- id: Integer
		Unique id of this Chest instance
		
# Class Variables
	- defaultInstance: Chest
		The default Chest instance
	- nextAvailableID: Integer
		The next id that is not used by any Chest. To be given to the next Chest that is created.
	- IDToChestInstance: Dictionary<Integer, Chest>
		Maps chest ids to chest instances
"
Class {
	#name : #Chest,
	#superclass : #Object,
	#instVars : [
		'contents',
		'name',
		'id'
	],
	#classVars : [
		'IDToChestInstance',
		'defaultInstance',
		'nextAvailableID',
		'subscribers'
	],
	#category : #Chest
}

{ #category : #accessing }
Chest class >> IDToChestInstance [
	^ IDToChestInstance
]

{ #category : #private }
Chest class >> IDToChestInstance: aValue [
	IDToChestInstance := aValue
]

{ #category : #api }
Chest class >> add: anObject [
	^ self defaultInstance add: anObject
]

{ #category : #accessing }
Chest class >> allChests [
	^ self IDToChestInstance values
]

{ #category : #api }
Chest class >> at: anIndex [
	^ self defaultInstance at: anIndex
]

{ #category : #api }
Chest class >> contents [
	^ self defaultInstance contents
]

{ #category : #accessing }
Chest class >> defaultInstance [
	^ defaultInstance
	
]

{ #category : #private }
Chest class >> getNewID [
	| newId |
	newId := nextAvailableID.
	nextAvailableID := nextAvailableID + 1.
	^ newId
]

{ #category : #'class initialization' }
Chest class >> initialize [
	subscribers := OrderedCollection new.
	IDToChestInstance := Dictionary new.
	nextAvailableID := 1.
"	defaultInstance := self newNamed: 'Default'."
	defaultInstance := DefaultChest newNamed: 'Default'
]

{ #category : #api }
Chest class >> new [
	| chest |
	chest := super new.
	chest name: 'Unnamed'.
	self IDToChestInstance at: chest id put: chest.
	self notifyNewChest: chest.
	^ chest.
]

{ #category : #api }
Chest class >> newNamed: aString [
	^ self new name: aString; yourself
]

{ #category : #'event system' }
Chest class >> notifyChestRemoved: aChest [
	subscribers do: [ :subscriber | subscriber event_chestRemoved: aChest]
]

{ #category : #'event system' }
Chest class >> notifyContentsOfChest: aChest updatedTo: contents [
	subscribers do: [ :subscriber | subscriber event_contentOfChest: aChest updatedTo: contents]
]

{ #category : #'event system' }
Chest class >> notifyNewChest: aChest [
	subscribers do: [ :subscriber | subscriber event_newChest: aChest ].
]

{ #category : #api }
Chest class >> remove: anObject [
	^ self defaultInstance remove: anObject
]

{ #category : #api }
Chest class >> removeAt: anIndex [
	^ self defaultInstance removeAt: anIndex
]

{ #category : #removing }
Chest class >> removeChest: aChest [
	self IDToChestInstance removeKey: aChest id.
	self notifyChestRemoved: aChest.
]

{ #category : #'event system' }
Chest class >> subscribeToUpdates: subscriber [
	"subscriber will be sent the #event_newChest: and #event_contentOfChest:updatedTo: and #event_chestRemoved: messages when these events happen"
	subscribers add: subscriber
]

{ #category : #'class initialization' }
Chest class >> withID: anID [
	"Returns the Chest whose id is @anID"
	^ self IDToChestInstance at: anID
]

{ #category : #api }
Chest >> add: anObject [
	"Adds an object to the chest. Returns the index at which it has been added."
	self contentsPrivate add: anObject.
	self contentsUpdated.
	^ contents size
]

{ #category : #api }
Chest >> at: anIndex [
	^ self contentsPrivate at: anIndex
]

{ #category : #accessing }
Chest >> contents [
	^ self contentsPrivate copy
]

{ #category : #accessing }
Chest >> contentsPrivate [
	^ contents
]

{ #category : #accessing }
Chest >> contentsUpdated [
	self class notifyContentsOfChest: self updatedTo: self contents
]

{ #category : #api }
Chest >> empty [
	self initializeContents.
	self contentsUpdated.
]

{ #category : #api }
Chest >> id [
	^ id
]

{ #category : #initialization }
Chest >> initialize [
	id := self class getNewID.
	self initializeContents.
]

{ #category : #initialization }
Chest >> initializeContents [
	contents := OrderedCollection new.
]

{ #category : #accessing }
Chest >> inspectAt: anIndex [
	^ (self contentsPrivate at: anIndex) inspect
]

{ #category : #api }
Chest >> name [
	name ifNil: [ name := '' ].
	^ name
]

{ #category : #accessing }
Chest >> name: anObject [
	name := anObject
]

{ #category : #removing }
Chest >> remove [
	"Remove this chest from the list of all chests"
	self class removeChest: self
]

{ #category : #accessing }
Chest >> remove: anObject [
	contents remove: anObject.
	self contentsUpdated.
]

{ #category : #accessing }
Chest >> removeAt: anIndex [
	self contentsPrivate removeAt: anIndex.
	self contentsUpdated.
]
