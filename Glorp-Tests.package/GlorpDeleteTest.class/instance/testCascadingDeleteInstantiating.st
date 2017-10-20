tests
testCascadingDeleteInstantiating
	| user |
	
	[self setUpFolders.
	self checkFoldersExistInDatabase.
	user := session readOneOf: GlorpUser where: [:each | each name = 'User One'].
	session beginUnitOfWork.
	user folders do: [:each | each printString].
	session delete: user.
	session commitUnitOfWork.
	self checkFoldersNotInCache.
	self checkFoldersDeletedInDatabase.
	self checkMessagesDeletedInDatabase] 
			ensure: [session rollbackTransaction]