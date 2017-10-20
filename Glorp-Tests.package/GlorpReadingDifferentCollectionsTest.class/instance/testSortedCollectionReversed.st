tests
testSortedCollectionReversed
	self check: (SortedCollection sortBlock: [:a :b | b <= a]).
	self deny: allResult last <= allResult first.