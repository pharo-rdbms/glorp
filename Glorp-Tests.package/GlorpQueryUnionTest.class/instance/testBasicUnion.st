tests-functional
testBasicUnion
	| query1 query2 union result |
	query1 := Query read: GlorpAddress where: [:each | each id = 1].
	query2 := Query read: GlorpAddress where: [:each | each id = 2].	
	union := query1 unionAll: query2.
	result := session execute: union.
	self assert: result size = 2.
	self assert: result first id = 1.
	self assert: result last id = 2.
	self assert: (result allSatisfy: [:each | each class == GlorpAddress]).