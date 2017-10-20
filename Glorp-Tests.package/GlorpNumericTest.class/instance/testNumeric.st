tests
testNumeric
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