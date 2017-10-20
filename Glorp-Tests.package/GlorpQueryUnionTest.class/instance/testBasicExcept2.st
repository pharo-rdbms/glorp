tests-functional
testBasicExcept2
	| query1 query2 union result |
	query1 := Query read: GlorpAddress where: [:each | each id in: #(1 2)].	
	query2 := Query read: GlorpAddress where: [:each | each id = 1].
	union := query1 except: query2.
	result := session execute: union.
	self assert: result size = 1.
	self assert: result first id = 2.