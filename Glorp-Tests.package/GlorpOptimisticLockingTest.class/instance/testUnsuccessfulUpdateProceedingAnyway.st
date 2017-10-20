tests
testUnsuccessfulUpdateProceedingAnyway
	| books |
	books := session read: GlorpBook.
	session accessor
		executeSQLStringNoResult: 'UPDATE BOOK SET COPIES_IN_STOCK = 7, VERSION = 3'.
	[self changeABookFrom: books] on: GlorpWriteFailure do: [:ex | ex resume: true].
		
	session reset.
	books := session read: GlorpBook.
	self assert: (books collect: [:each | each copiesInStock]) = #( 7 7).