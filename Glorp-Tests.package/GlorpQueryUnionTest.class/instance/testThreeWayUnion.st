tests-functional
testThreeWayUnion
	| query1 query2 union result query3 |
	query1 := Query read: GlorpAddress where: [:each | each id = 1].
	query2 := Query read: GlorpAddress where: [:each | each id = 2].	
	query3 := Query read: GlorpAddress where: [:each | each id = 3].	

	union := (query1 unionAll: query2) unionAll: query3.
	union orderBy: [:each | each id].
	result := session execute: union.
	self assert: result size = 3.
	self assert: result first id = 1.
	self assert: result last id = 3.
	self assert: (result allSatisfy: [:each | each class == GlorpAddress]).