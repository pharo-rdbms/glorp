tests-functional
testOrderByInUnion
	| query1 query2 union result |
	self writePeople.
	query1 := Query read: GlorpAddress where: [:each | each id > 1].
	query1 retrieve: #id.
	query2 := Query read: GlorpPerson.
	query2 retrieve: [:each | each id].
	union := query1 unionAll: query2.
	union orderBy: [:each | each id descending].
	result := session execute: union.
	self assert: result = #(87 86 3 2).