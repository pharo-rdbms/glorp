Class {
	#name : #GlorpDecimalTest,
	#superclass : #GlorpDatabaseTypeIndividualDBTests,
	#category : 'Glorp-Tests-DatabaseTypes'
}

{ #category : #types }
GlorpDecimalTest >> defaultDatabaseType [

	^self platform decimal.
]

{ #category : #tests }
GlorpDecimalTest >> testDecimal [
	"Decimals aren't guaranteed to be exact (the fraction may be different) so use the float helper"

	self helpTestFloat: nil.
	self helpTestValue: 3.1415s4 compareWith: [:read :original |
		(read - original) abs <= 0.00001].
]
