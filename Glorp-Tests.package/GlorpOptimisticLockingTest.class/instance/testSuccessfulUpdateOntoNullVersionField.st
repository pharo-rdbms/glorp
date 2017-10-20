tests
testSuccessfulUpdateOntoNullVersionField
	| books copies someBook |
	someBook := session readOneOf: GlorpBook.
	session accessor executeSQLString: 'UPDATE BOOK SET VERSION = NULL WHERE ID = ', someBook id printString. 
	session reset.
	books := session read: GlorpBook orderBy: #id.
		copies := books collect: [:each | each copiesInStock].
	session transact: [
		session register: books.
		books do: [:each | each copiesInStock: (each copiesInStock - 1)]].
	session reset.
	books := session read: GlorpBook orderBy: #id.
	self assert: (books collect: [:each | each copiesInStock]) = (copies collect: [:each | each - 1]).