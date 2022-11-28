Class {
	#name : #GlorpInt2Test,
	#superclass : #GlorpDatabaseTypeIndividualDBTests,
	#category : #'Glorp-Integration-Tests-DatabaseTypes'
}

{ #category : #types }
GlorpInt2Test >> defaultDatabaseType [
	^self platform int2.
]

{ #category : #tests }
GlorpInt2Test >> testBooleanToInteger [
	stType := Boolean.
	self helpTestValue: nil.
	self helpTestValue: true.
	self helpTestValue: false.
]

{ #category : #tests }
GlorpInt2Test >> testInt2 [
	self helpTestValue: nil.
	self helpTestValue: 32123.
]
