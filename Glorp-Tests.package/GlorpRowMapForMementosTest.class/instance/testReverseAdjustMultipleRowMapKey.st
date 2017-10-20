tests
testReverseAdjustMultipleRowMapKey
	| rowMapKey adjustedKey  |
	rowMapKey := MultipleRowMapKey with: a2 with: b2 with: c2.
	adjustedKey := rowMapKey reverseAdjustIn: rowMap.
	self assert: (adjustedKey keys includes: a1).
	self assert: (adjustedKey keys includes: b1).
	self assert: (adjustedKey keys includes: c1).