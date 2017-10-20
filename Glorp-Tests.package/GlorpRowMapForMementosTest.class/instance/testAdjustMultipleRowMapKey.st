tests
testAdjustMultipleRowMapKey
	| rowMapKey adjustedKey  |
	rowMapKey := MultipleRowMapKey with: a1 with: b1 with: c1.
	adjustedKey := rowMapKey adjustIn: rowMap correspondenceMap.
	self assert: (adjustedKey keys includes: a2).
	self assert: (adjustedKey keys includes: b2).
	self assert: (adjustedKey keys includes: c2).