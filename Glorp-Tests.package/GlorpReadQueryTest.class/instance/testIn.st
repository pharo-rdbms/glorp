tests
testIn
	| query result |
	
	query := Query read: GlorpAddress where: [:each | each street in: #('Beta' 'Alpha')].
	result := session execute: query.
	self assert: (result allSatisfy: [:each | #('Beta' 'Alpha') includes: each street]).
	self assert: result size = 4.