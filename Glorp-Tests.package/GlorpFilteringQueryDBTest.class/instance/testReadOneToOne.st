tests
testReadOneToOne
	| people addressMapping |
	session writeRow: session system exampleAddressRowForOrdering1.
	session writeRow: session system exampleAddressRowForOrdering2.
	session writeRow: session system exampleAddressRowForOrdering3.

	session writeRow: session system examplePersonRowForOrdering1.
	session writeRow: session system examplePersonRowForOrdering2.
	session writeRow: session system examplePersonRowForOrdering3.

	addressMapping := (system descriptorFor: GlorpPerson) mappingForAttributeNamed: #address.
	addressMapping useFilteredRead.
	people := session execute: (Query read: GlorpPerson where: [:each | each id ~= 2]).
	people first address yourSelf.
	session accessor permitNothing.
	people := people asSortedCollection: [:a :b | a id <= b id].
	self assert: people first address id = 2.
	self assert: (people at: 2) address id = 3.
	self assert: (people at: 3) address id = 1.
	self assert: people size = 3.