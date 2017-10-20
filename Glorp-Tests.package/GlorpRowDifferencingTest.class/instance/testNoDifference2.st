tests
testNoDifference2
	| |
	currentObject := GlorpPerson example1.
	mementoObject := GlorpPerson example1.
	self computeDifference.
	self assert: differenceMap numberOfEntries = 0.