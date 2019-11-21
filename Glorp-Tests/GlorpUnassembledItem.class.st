Class {
	#name : #GlorpUnassembledItem,
	#superclass : #GlorpNonperishableItem,
	#instVars : [
		'assemblyCost'
	],
	#category : 'Glorp-Tests-Models'
}

{ #category : #accessing }
GlorpUnassembledItem >> assemblyCost [
	^assemblyCost
]

{ #category : #accessing }
GlorpUnassembledItem >> assemblyCost: anObject [
	assemblyCost := anObject
]
