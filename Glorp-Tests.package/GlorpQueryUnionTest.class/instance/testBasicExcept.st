tests-functional
testBasicExcept
	| query1 query2 union result |
	query1 := Query read: GlorpAddress where: [:each | each id = 1].
	query2 := Query read: GlorpAddress where: [:each | each id = 2].	
	union := query1 except: query2.
	result := session execute: union.
	self assert: result size = 1.