tests-functional
testBasicIntersect2
	| query1 query2 union result |
	query1 := Query read: GlorpAddress where: [:each | each id = 1].
	query2 := Query read: GlorpAddress where: [:each | each id in: #(1 2)].	
	union := query1 intersect: query2.
	result := session execute: union.
	self assert: result size = 1.