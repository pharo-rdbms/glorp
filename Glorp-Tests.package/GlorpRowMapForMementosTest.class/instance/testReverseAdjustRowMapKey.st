tests
testReverseAdjustRowMapKey
	| rowMapKey adjustedKey  |
	rowMapKey := RowMapKey new.
	rowMapKey key1: a2; key2: b2.
	adjustedKey := rowMapKey reverseAdjustIn: rowMap.
	self assert: (adjustedKey key1 == a1).
	self assert: (adjustedKey key2 == b1).