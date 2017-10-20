tests-functional
testUnionWithRetrieveThoroughlyDisaparateResults2
	"The tables will get aliased differently, make sure that works"

	| query1 query2 union result |
	self writePeople.
	query1 := Query read: GlorpAddress where: [:each | each id = 2].
	query1 retrieve: [:each | each street].
	query2 := Query read: GlorpPerson where: [:each | each id = 87].
	query2 retrieve: [:each | each address street].
	union := query1 unionAll: query2.
	result := session execute: union.
	self assert: result asSortedCollection asArray = #('Beta' 'Gamma').