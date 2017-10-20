tests
testNumericCoercion

	| type platform num |
	type := GlorpNumericType new scale: 5; precision: 2.
	platform := DatabasePlatform new.
	num := Dialect coerceToDoublePrecisionFloat: (123456 / 100).
	self assert: (platform convertToNumber: num for: type) = num.
	num := Dialect coerceToDoublePrecisionFloat: (123450 / 100).
	self assert: (platform convertToNumber: num for: type) = num.
	num := Dialect coerceToDoublePrecisionFloat: (123450 / 1000).
	self assert: (platform convertToNumber: num for: type) = num.
	num := Dialect coerceToDoublePrecisionFloat: (123456 / 1000).
	self deny: (platform convertToNumber: num for: type) = num.