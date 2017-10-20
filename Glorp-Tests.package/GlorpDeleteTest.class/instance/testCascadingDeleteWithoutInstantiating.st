tests
testCascadingDeleteWithoutInstantiating
	| user |
	
	[self setUpFolders.
	self checkFoldersExistInDatabase.
	user := session readOneOf: GlorpUser where: [:each | each name = 'User One'].
	session beginUnitOfWork.
	session delete: user.
	session commitUnitOfWork.
	self checkFoldersNotInCache.
	self checkFoldersDeletedInDatabase] 
			ensure: [session rollbackTransaction]