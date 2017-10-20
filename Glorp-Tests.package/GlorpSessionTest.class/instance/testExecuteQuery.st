tests
testExecuteQuery
	| q result |
	q := GlorpQueryStub new result: 3.
	result := session execute: q.
	self assert: result = 3