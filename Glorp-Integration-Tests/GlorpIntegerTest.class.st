Class {
	#name : #GlorpIntegerTest,
	#superclass : #GlorpDatabaseTypeIndividualDBTests,
	#category : #'Glorp-Integration-Tests-DatabaseTypes'
}

{ #category : #types }
GlorpIntegerTest >> defaultDatabaseType [
	^self platform integer.
]

{ #category : #tests }
GlorpIntegerTest >> testInteger [
	type := (self platform) integer.
	self helpTestValue: nil.
	self helpTestValue: 3212321.
]
