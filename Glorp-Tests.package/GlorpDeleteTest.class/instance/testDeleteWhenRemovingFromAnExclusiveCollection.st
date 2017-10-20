tests
testDeleteWhenRemovingFromAnExclusiveCollection
	| user removed result generalResult |
	
	[self setUpFolders.
	self checkFoldersExistInDatabase.
	user := session readOneOf: GlorpUser where: [:each | each name = 'User One'].
	session modify: user in: [
		user folders do: [:each | each printString].
		removed := user folders detect: [:each | each name = 'One'].
		user folders remove: removed].
	self assert: (session cacheLookupForClass: GlorpFolder key: #(1 'One')) isNil.
	result := session accessor executeSQLString: 'SELECT * FROM GR_FOLDER WHERE USER_ID=1'.
	self assert: result size = 1.

	generalResult := session accessor executeSQLString: 'SELECT * FROM GR_FOLDER'.
	self assert: generalResult size = 2.

	result := session accessor executeSQLString: 'SELECT * FROM GR_MESSAGE WHERE USER_ID = 1'.
	self assert: result isEmpty.

	generalResult := session accessor executeSQLString: 'SELECT * FROM GR_MESSAGE'.
	self assert: generalResult size = 1.] 
			ensure: [session rollbackTransaction]