tests
testSortedCollection
	self check: SortedCollection.
	self assert: allResult first <= allResult last.