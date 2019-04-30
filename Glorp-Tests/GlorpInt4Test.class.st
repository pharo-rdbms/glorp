Class {
	#name : #GlorpInt4Test,
	#superclass : #GlorpDatabaseTypeIndividualDBTests,
	#category : 'Glorp-Tests-DatabaseTypes'
}

{ #category : #'*Glorp-Tests' }
GlorpInt4Test class >> new [
	"Answer a newly created and initialized instance."

	^super new initialize
]

{ #category : #types }
GlorpInt4Test >> defaultDatabaseType [
	^self platform int4
]

{ #category : #tests }
GlorpInt4Test >> testInt4 [
	self helpTestValue: nil.
	self helpTestValue: 3212321.
]
