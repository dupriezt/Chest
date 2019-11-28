Class {
	#name : #ChestEventListenerForTest,
	#superclass : #Object,
	#instVars : [
		'chestRemovedReceived',
		'contentOfChestUpdatedReceived',
		'newChestReceived',
		'removedChest',
		'updatedChest',
		'newContentsOfUpdatedChest',
		'newChest'
	],
	#category : #'Chest-Tests'
}

{ #category : #accessing }
ChestEventListenerForTest >> chestRemovedReceived [
	^ chestRemovedReceived
]

{ #category : #accessing }
ChestEventListenerForTest >> contentOfChestUpdatedReceived [
	^ contentOfChestUpdatedReceived
]

{ #category : #initialization }
ChestEventListenerForTest >> event_chestRemoved: aChest [
	chestRemovedReceived := true.
	removedChest := aChest
]

{ #category : #initialization }
ChestEventListenerForTest >> event_contentOfChest: aChest updatedTo: contents [
	contentOfChestUpdatedReceived := true.
	updatedChest := aChest.
	newContentsOfUpdatedChest := contents

]

{ #category : #initialization }
ChestEventListenerForTest >> event_newChest: aChest [
	newChestReceived := true.
	newChest := aChest
]

{ #category : #initialization }
ChestEventListenerForTest >> initialize [
	chestRemovedReceived := false.
	contentOfChestUpdatedReceived := false.
	newChestReceived := false
]

{ #category : #accessing }
ChestEventListenerForTest >> newChest [
	^ newChest
]

{ #category : #accessing }
ChestEventListenerForTest >> newChestReceived [
	^ newChestReceived
]

{ #category : #accessing }
ChestEventListenerForTest >> newContentsOfUpdatedChest [
	^ newContentsOfUpdatedChest
]

{ #category : #accessing }
ChestEventListenerForTest >> removedChest [
	^ removedChest
]

{ #category : #accessing }
ChestEventListenerForTest >> updatedChest [
	^ updatedChest
]
