tests-functional
testUnionWithRetrieveThoroughlyDisaparateResults
	"Fields from mismatched tables"
	| query1 query2 union result |
	self writePeople.
	query1 := Query read: GlorpAddress.
	query1 retrieve: [:each | each street].
	query2 := Query read: GlorpPerson.
	query2 retrieve: [:each | each name].
	union := query1 unionAll: query2.
	result := session execute: union.
	self assert: result asSortedCollection asArray = #('Alpha' 'Beta' 'Gamma' 'person1' 'person2').