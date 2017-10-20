tests
testDeleteAndReinsertTwiceWhenRemovingFromAnExclusiveCollection
	"Make sure that if we add a new thing twice, we get the expected failure of a primary key conflict."

	| user |
	[self setUpFolders.
	self checkFoldersExistInDatabase.
	user := session
		readOneOf: GlorpUser
		where: [:each | each name = 'User One'].
	self
		should: [self doDeleteAndDoubleAddOfFoldersFor: user]
		raise: GlorpDatabaseWriteError] ensure: [session rollbackTransaction].