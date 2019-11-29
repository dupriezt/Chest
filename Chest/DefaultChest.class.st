Class {
	#name : #DefaultChest,
	#superclass : #Chest,
	#category : #Chest
}

{ #category : #removing }
DefaultChest >> remove [
	"The default chest cannot be removed"

	^ self
]
