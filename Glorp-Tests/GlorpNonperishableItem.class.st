Class {
	#name : #GlorpNonperishableItem,
	#superclass : #GlorpInventoryItem,
	#instVars : [
		'serialNumber'
	],
	#category : 'Glorp-Tests-Models'
}

{ #category : #accessing }
GlorpNonperishableItem >> serialNumber [
	^serialNumber
]

{ #category : #accessing }
GlorpNonperishableItem >> serialNumber: anObject [
	serialNumber := anObject
]
