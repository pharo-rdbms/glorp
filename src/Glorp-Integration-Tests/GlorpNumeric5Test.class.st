Class {
	#name : #GlorpNumeric5Test,
	#superclass : #GlorpDatabaseTypeIndividualDBTests,
	#category : #'Glorp-Integration-Tests-DatabaseTypes'
}

{ #category : #types }
GlorpNumeric5Test >> defaultDatabaseType [
	^self platform numeric scale: 5.
]

{ #category : #tests }
GlorpNumeric5Test >> testNumeric5 [

	| fixed |

	self platform supportsVariableSizedNumerics ifFalse: [^self].

	self helpTestFloat: nil.
	self helpTestFloat: 12.
	self helpTestFloat: 10991.
	self helpTestFloat: (Dialect readFixedPointFrom: '3.0').
	fixed := Dialect readFixedPointFrom: '321.12'.
	self platform supportsDecimalsOnAllNumerics
		ifTrue: [
			self helpTestFloat: fixed.
			self helpTestFloat: 3.14]
		ifFalse: [
			self helpTestInvalidValue: fixed.
			self helpTestInvalidValue: 3.14].
]
