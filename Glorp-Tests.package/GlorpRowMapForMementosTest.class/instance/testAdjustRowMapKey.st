tests
testAdjustRowMapKey
	| rowMapKey adjustedKey  |
	rowMapKey := RowMapKey new.
	rowMapKey key1: a1; key2: b1.
	adjustedKey := rowMapKey adjustIn: rowMap correspondenceMap.
	self assert: (adjustedKey key1 == a2).
	self assert: (adjustedKey key2 == b2).