Class {
	#name : #GlorpNumericTest,
	#superclass : #GlorpDatabaseTypeIndividualDBTests,
	#category : #'Glorp-Integration-Tests-DatabaseTypes'
}

{ #category : #types }
GlorpNumericTest >> defaultDatabaseType [
	"DB2 default precision is only 5, which needs to be increased for this test."

	^self platform isDB2Platform
		ifTrue: [self platform numeric precision: 10]
		ifFalse: [self platform numeric]
]

{ #category : #tests }
GlorpNumericTest >> testNumeric [
	| floatSelector |
	self helpTestFloat: 12.	
	self helpTestFloat: nil.
	self helpTestFloat: (Dialect readFixedPointFrom: '12345678').
	self platform supportsDecimalsOnAllNumerics ifTrue: [
		self helpTestValue: 3.14  compareWith: [:read :original |
			read - original <= 0.00001]]
		ifFalse: [self helpTestInvalidValue: 3.14].
	floatSelector := self platform supportsDecimalsOnAllNumerics ifTrue: [#helpTestFloat:] ifFalse: [#helpTestInvalidValue:].
	self perform: floatSelector with: (Dialect coerceToDoublePrecisionFloat:  321.12).
	self perform: floatSelector with: (Dialect coerceToDoublePrecisionFloat: 321.123).
	self perform: floatSelector with: (Dialect coerceToDoublePrecisionFloat: (Dialect readFixedPointFrom: '321.123456789')).
	self perform: floatSelector with: (Dialect coerceToDoublePrecisionFloat: 3.14).
	self perform: floatSelector with: (Dialect coerceToDoublePrecisionFloat: 3.1).
	self perform: floatSelector with: (Dialect readFixedPointFrom:  '321.12').
	self perform: floatSelector with: (Dialect readFixedPointFrom: '321.123').
	self perform: floatSelector with: (Dialect readFixedPointFrom: '3.14').
	self perform: floatSelector with: (Dialect readFixedPointFrom: '3.1').
]
