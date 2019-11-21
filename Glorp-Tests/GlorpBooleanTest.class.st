Class {
	#name : #GlorpBooleanTest,
	#superclass : #GlorpDatabaseTypeIndividualDBTests,
	#category : 'Glorp-Tests-DatabaseTypes'
}

{ #category : #types }
GlorpBooleanTest >> defaultDatabaseType [
	^self platform boolean.
]

{ #category : #tests }
GlorpBooleanTest >> testBoolean [
	stType := Boolean.
	self helpTestValue: nil compareWith: [:read :original |
		self platform usesNullForFalse ifTrue: [read = false] ifFalse: [read = nil]].
	self helpTestValue: true.
	self helpTestValue: false.
]
