"
Represents an object stored in a Chest

# Instance Variables
	- name: String
		Name that was given to this ChestObject when it was stored
	- contents: Object
		Stored object this ChestObject represents
"
Class {
	#name : #ChestObject,
	#superclass : #Object,
	#instVars : [
		'name',
		'contents'
	],
	#category : #Chest
}

{ #category : #accessing }
ChestObject >> contents [
	^ contents
]

{ #category : #accessing }
ChestObject >> contents: anObject [
	contents := anObject
]

{ #category : #accessing }
ChestObject >> name [
	^ name
]

{ #category : #accessing }
ChestObject >> name: anObject [
	name := anObject
]
