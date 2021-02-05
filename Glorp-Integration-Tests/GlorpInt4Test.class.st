Class {
	#name : #GlorpInt4Test,
	#superclass : #GlorpDatabaseTypeIndividualDBTests,
	#category : #'Glorp-Integration-Tests-DatabaseTypes'
}

{ #category : #types }
GlorpInt4Test >> defaultDatabaseType [
	^self platform int4
]

{ #category : #tests }
GlorpInt4Test >> testInt4 [
	self helpTestValue: nil.
	self helpTestValue: 3212321.
]
