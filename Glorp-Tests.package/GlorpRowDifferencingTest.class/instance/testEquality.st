tests
testEquality
	| addressRow1 addressRow2 |
	addressRow1 := session system exampleAddressRow.
	addressRow2 := session system exampleAddressRowWithDifferentStreet.
	self assert: (addressRow1 equals: addressRow1).
	self assert: (addressRow1 equals: addressRow2) not.