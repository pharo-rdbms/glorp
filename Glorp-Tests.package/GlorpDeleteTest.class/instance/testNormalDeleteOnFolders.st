tests
testNormalDeleteOnFolders
	| user |
	
	[self setUpFolders.
	self checkFoldersExistInDatabase.
	user := session readOneOf: GlorpUser where: [:each | each name = 'User One'].
	session beginUnitOfWork.
	session delete: user.
	user folders do: [:each | 
		session delete: each.
		each messages do: [:eachMessage |
			session delete: eachMessage]].
	session commitUnitOfWork.
	self checkFoldersNotInCache.
	self checkFoldersDeletedInDatabase.
	self checkMessagesDeletedInDatabase] 
			ensure: [session rollbackTransaction]