Class {
	#name : #GlorpNumeric52Test,
	#superclass : #GlorpDatabaseTypeIndividualDBTests,
	#category : 'Glorp-Tests-DatabaseTypes'
}

{ #category : #types }
GlorpNumeric52Test >> defaultDatabaseType [
	^(self platform numeric)
		precision: 5;
		scale: 2.
]

{ #category : #tests }
GlorpNumeric52Test >> testNumeric52 [
	self platform supportsVariableSizedNumerics ifFalse: [^self].
	self helpTestFloat: nil.
	self helpTestFloat: 12.
	self helpTestFloat: 321.12.
	self helpTestInvalidValue: 17.098.
	self helpTestFloat: 3.14.
	self helpTestFloat: (Dialect coerceToDoublePrecisionFloat: 12).
	self helpTestFloat: (Dialect coerceToDoublePrecisionFloat: 321.12).
	self helpTestInvalidValue: (Dialect coerceToDoublePrecisionFloat: 17.098).
	self helpTestFloat: (Dialect coerceToDoublePrecisionFloat: 3.14).
	self helpTestFloat: (Dialect readFixedPointFrom: '321.12').
	self helpTestInvalidValue: (Dialect readFixedPointFrom: '321.123').
	self helpTestFloat: (Dialect readFixedPointFrom: '3.14').
	self helpTestFloat: (Dialect readFixedPointFrom: '3.1' ).
]
