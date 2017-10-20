tests
testDeleteAndReinsertWhenRemovingFromAnExclusiveCollection
	"Test that if we delete something and then re-insert with the same primary key, that it gets converted to an update. This is not really advisable as something to do, since you're really violating the primary key = object identity correspondence, but it can reasonably happen if you're using domain primary keys, link tables reified as objects, or other circumstances"
	| user removed result generalResult new |
	
	[self setUpFolders.
	self checkFoldersExistInDatabase.
	user := session readOneOf: GlorpUser where: [:each | each name = 'User One'].
	session modify: user in: [
		user folders do: [:each | each printString].
		removed := user folders detect: [:each | each name = 'One'].
		user folders remove: removed.
		new := GlorpFolder new name: 'One'.
		new user: user.
		user folders add: new].
	self assert: (session cacheLookupForClass: GlorpFolder key: #(1 'One')) == new.
	result := session accessor executeSQLString: 'SELECT * FROM GR_FOLDER WHERE USER_ID=1'.
	self assert: result size = 2.

	generalResult := session accessor executeSQLString: 'SELECT * FROM GR_FOLDER'.
	self assert: generalResult size = 3.

	result := session accessor executeSQLString: 'SELECT * FROM GR_MESSAGE WHERE USER_ID = 1'.
	self assert: result isEmpty.

	generalResult := session accessor executeSQLString: 'SELECT * FROM GR_MESSAGE'.
	self assert: generalResult size = 1.] 
			ensure: [session rollbackTransaction]