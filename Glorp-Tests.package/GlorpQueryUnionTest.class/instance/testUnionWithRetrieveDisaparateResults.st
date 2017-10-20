tests-functional
testUnionWithRetrieveDisaparateResults
	| query1 query2 union result |
	self writePeople.
	query1 := Query read: GlorpAddress.
	query1 retrieve: #id.
	query2 := Query read: GlorpPerson.
	query2 retrieve: #id.
	union := query1 unionAll: query2.
	result := session execute: union.
	self assert: result asSortedCollection asArray = #(1 2 3 86 87).