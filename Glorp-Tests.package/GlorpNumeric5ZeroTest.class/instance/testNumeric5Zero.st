tests
testNumeric5Zero
	self platform supportsVariableSizedNumerics ifFalse: [^self].

	self helpTestFloat: nil.
	self helpTestFloat: 12.	
	self helpTestFloat: 10991.		
	self helpTestFloat: (Dialect coerceToDoublePrecisionFloat: 3.0).
	self helpTestInvalidValue: (Dialect coerceToDoublePrecisionFloat: 321.12).
	self helpTestFloat: (Dialect readFixedPointFrom: '3.0').
	self helpTestInvalidValue: (Dialect readFixedPointFrom: '321.12').
	self helpTestInvalidValue: 3.14.