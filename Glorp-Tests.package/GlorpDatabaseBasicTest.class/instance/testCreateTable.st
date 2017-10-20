tests
testCreateTable
	| selectResult presentFlag |
	presentFlag := true.
	[[self accessor beginTransaction.
	self accessor
		executeSQLStringNoResult: 'CREATE TABLE GLORP_TEST_CREATE (ID varchar(4))'] 
		ensure: [self accessor commitTransaction].
	selectResult := self accessor
		executeSQLString: 'SELECT * FROM GLORP_TEST_CREATE'.
	self assert: selectResult isEmpty]
		ensure:
			[[self accessor
				beginTransaction;
				dropTableNamed: 'GLORP_TEST_CREATE'
					ifAbsent: [:ex |presentFlag := false. ex sunitExitWith: nil]]
				ensure: [self accessor commitTransaction]].
	self assert: presentFlag
		description: 'Tried to drop the created table but it was already absent'.