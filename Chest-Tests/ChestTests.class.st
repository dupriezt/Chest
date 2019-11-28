Class {
	#name : #ChestTests,
	#superclass : #TestCase,
	#category : #'Chest-Tests'
}

{ #category : #tests }
ChestTests >> testAddRemoveToChest [
	self testAddRemoveToChest: Chest new.
]

{ #category : #tests }
ChestTests >> testAddRemoveToChest: aChest [
	| c o1 o2 |
	c := aChest.
	o1 := Object new.
	o2 := Object new.
	self assert: c contents size equals: 0.
	c add: o1; add: o2.
	self assert: c contents size equals: 2.
	self assert: (c at: 1) equals: o1.
	self assert: (c at: 2) equals: o2.
	c remove: o2.
	c removeAt: 1.
	self assert: c contents size equals: 0.
	
]

{ #category : #tests }
ChestTests >> testAddRemoveToDefaultChest [
	"Tests that the Chest class itself works as a chest"
	self testAddRemoveToChest: Chest.
]

{ #category : #tests }
ChestTests >> testAlwaysGiveFreshIDToNewChests [
	| c1 c2 c3 idList c4 |
	c1 := Chest new.
	c2 := Chest new.
	c3 := Chest new.
	self assert: c1 id ~= c2 id.
	self assert: c2 id ~= c3 id.
	self assert: c1 id ~= c3 id.
	idList := OrderedCollection new.
	idList add: (c1 id); add: (c2 id); add: (c3 id).
	Chest removeChest: c3.
	c4 := Chest new.
	self assert: ((idList includes: c4 id) not).
	
	
]

{ #category : #tests }
ChestTests >> testDefaultInstance [
	"Tests that the default instance of the Chest class does exist"
	self assert: (Chest defaultInstance isKindOf: Chest).
]

{ #category : #tests }
ChestTests >> testGettingChestFromID [
	"Tests that retrieving chests by their id works"
	| c1 c2 |
	c1 := Chest new.
	c2 := Chest new.
	self assert: (Chest withID: c1 id) identicalTo: c1.
	self assert: (Chest withID: c2 id) identicalTo: c2.
	"Tests that accessing a removed chest signals an error"
	Chest removeChest: c2.
	self should: [ Chest withID: c2 id ] raise: Error.
]

{ #category : #tests }
ChestTests >> testNotifications [
	"Tests that the Chest class does indeed send the notifications it is supposed to"
	| l c o |
	l := ChestEventListenerForTest new.
	Chest subscribeToUpdates: l.
	"Tests that no event has been received so far"
	self assert: l newChestReceived not.
	self assert: l contentOfChestUpdatedReceived not.
	self assert: l chestRemovedReceived not.
	
	"Test the event on chest creation"
	c := Chest new.
	self assert: l newChestReceived.
	self assert: l newChest identicalTo: c.
	
	"Test the event on chest content update"
	o := Object new.
	c add: Object new.
	self assert: l contentOfChestUpdatedReceived.
	self assert: l updatedChest identicalTo: c.
	self assert: l newContentsOfUpdatedChest equals: c contents.
	
	"Test the event on chest removal"
	Chest removeChest: c.
	self assert: l chestRemovedReceived.
	self assert: l removedChest identicalTo: c.
]
