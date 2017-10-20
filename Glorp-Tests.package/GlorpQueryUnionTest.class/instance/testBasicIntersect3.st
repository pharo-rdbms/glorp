tests-functional
testBasicIntersect3
	| query1 query2 union result |
	query1 := Query read: GlorpAddress where: [:each | each id = 1].
	query2 := Query read: GlorpAddress where: [:each | each street = 'Alpha'].	
	union := query1 intersect: query2.
	result := session execute: union.
	self assert: result size = 1.