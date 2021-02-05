Class {
	#name : #GlorpInt8Test,
	#superclass : #GlorpDatabaseTypeIndividualDBTests,
	#category : #'Glorp-Integration-Tests-DatabaseTypes'
}

{ #category : #types }
GlorpInt8Test >> defaultDatabaseType [
	^self platform int8
]

{ #category : #tests }
GlorpInt8Test >> testInt8 [
	type := (self platform) int8.
	self helpTestValue: nil.
	self helpTestValue: 3212321555.
]
