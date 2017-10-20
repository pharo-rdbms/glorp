tests
testNameBinding
	| selectResult |
	"This is more of a low-level db functionality test than a glorp test, but it's convenient to be able ot write it here"
	self accessor platform supportsBinding ifFalse: [^self skip: 'Current database platform does not support parameter binding.'].
	[self accessor beginTransaction.
	self accessor executeSQLStringNoResult: 'INSERT INTO STUFF VALUES (10,''abc'')'.
	self accessor executeSQLStringNoResult: 'INSERT INTO STUFF VALUES (20,''def'')'.
	self accessor executeSQLStringNoResult: 'INSERT INTO STUFF VALUES (30,''ghi'')'.
	selectResult := self accessor 
		executeSQLString: 'SELECT * FROM STUFF WHERE ID = ? OR ID = ?'
			binding: {10. 30}.

	self assert: selectResult size = 2]
		ensure: [self accessor rollbackTransaction].