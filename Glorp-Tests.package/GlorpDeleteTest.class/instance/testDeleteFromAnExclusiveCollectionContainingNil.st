tests
testDeleteFromAnExclusiveCollectionContainingNil
	| user removed |
	
	[self setUpFolders.
	self checkFoldersExistInDatabase.
	user := session readOneOf: GlorpUser where: [:each | each name = 'User One'].
	session modify: user in: [
		user folders do: [:each | each printString].
		removed := user folders detect: [:each | each name = 'One'].
		user folders remove: removed.
		user folders add: nil]
	"The only assertion is that we shouldn't be crashing here."
	] 
			ensure: [session rollbackTransaction]