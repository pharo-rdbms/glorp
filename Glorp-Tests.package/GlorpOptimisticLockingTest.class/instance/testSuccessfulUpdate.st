tests
testSuccessfulUpdate
	| books versions newVersions |
	books := session read: GlorpBook orderBy: #id.
	versions := (session accessor executeSQLString: 'SELECT VERSION FROM BOOK ORDER BY ID') collect: [:each | each first].
	session modify: books in: [
		books do: [:each | each copiesInStock: (each copiesInStock * 2)]].
	newVersions := (session accessor executeSQLString: 'SELECT VERSION FROM BOOK ORDER BY ID') collect: [:each | each first].
	self assert: newVersions = (versions collect: [:each | each + 1]).