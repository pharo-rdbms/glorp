tests
testLike
	| query result |
	
	query := Query read: GlorpAddress where: [:each | each street like: 'Be%'].
	result := session execute: query.
	self assert: (result allSatisfy: [:each | each street = 'Beta']).
	self assert: result size = 3.