Class {
	#name : #GlorpNumeric5ZeroTest,
	#superclass : #GlorpDatabaseTypeIndividualDBTests,
	#category : 'Glorp-Tests-DatabaseTypes'
}

{ #category : #tests }
GlorpNumeric5ZeroTest >> defaultDatabaseType [
	^self platform numeric precision: 5; scale: 0.
]

{ #category : #tests }
GlorpNumeric5ZeroTest >> testNumeric5Zero [
	self platform supportsVariableSizedNumerics ifFalse: [^self].

	self helpTestFloat: nil.
	self helpTestFloat: 12.	
	self helpTestFloat: 10991.		
	self helpTestFloat: (Dialect coerceToDoublePrecisionFloat: 3.0).
	self helpTestInvalidValue: (Dialect coerceToDoublePrecisionFloat: 321.12).
	self helpTestFloat: (Dialect readFixedPointFrom: '3.0').
	self helpTestInvalidValue: (Dialect readFixedPointFrom: '321.12').
	self helpTestInvalidValue: 3.14.
]
