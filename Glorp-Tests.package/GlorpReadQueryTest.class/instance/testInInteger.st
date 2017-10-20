tests
testInInteger
	| query result |
	
	query := Query read: GlorpAddress where: [:each | each id in: #(1 2)].
	result := session execute: query.
	self assert: (result allSatisfy: [:each | #(1 2) includes: each id]).
	self assert: result size = 2.