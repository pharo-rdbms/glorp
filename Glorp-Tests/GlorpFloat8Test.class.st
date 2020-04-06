Class {
	#name : #GlorpFloat8Test,
	#superclass : #GlorpDatabaseTypeIndividualDBTests,
	#category : 'Glorp-Tests-DatabaseTypes'
}

{ #category : #types }
GlorpFloat8Test >> defaultDatabaseType [
	^self platform float8
]

{ #category : #types }
GlorpFloat8Test >> testFloat8 [
	type := (self platform) double.

	self helpTestFloat: nil.
	self helpTestValue: (Dialect coerceToDoublePrecisionFloat: 3.14) compareWith: [:read :original |
		read - original <= 0.0000001].
]
