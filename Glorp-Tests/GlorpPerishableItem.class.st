Class {
	#name : #GlorpPerishableItem,
	#superclass : #GlorpInventoryItem,
	#instVars : [
		'age'
	],
	#category : 'Glorp-Tests-Models'
}

{ #category : #accessing }
GlorpPerishableItem >> age [
	^age
]

{ #category : #accessing }
GlorpPerishableItem >> age: anObject [
	age := anObject
]
