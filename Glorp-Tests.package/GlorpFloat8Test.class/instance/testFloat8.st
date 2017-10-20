types
testFloat8
	type := (self platform) double.

	self helpTestFloat: nil.
	self helpTestValue: (Dialect coerceToDoublePrecisionFloat: 3.14) compareWith: [:read :original |
		read - original <= 0.0000001].