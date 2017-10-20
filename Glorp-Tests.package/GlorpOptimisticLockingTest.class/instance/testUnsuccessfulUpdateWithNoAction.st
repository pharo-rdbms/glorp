tests
testUnsuccessfulUpdateWithNoAction
	"This is a little quirky. SUnit's action in should:raise: is to exit the exception with true. So the thing just short circuits, and we don't get a transaction failure because we killed the whole unit of work. This is, in general, what will happen if we handle and don't resume the write failures."
	| books |
	books := session read: GlorpBook.
	session accessor
		executeSQLStringNoResult: 'UPDATE BOOK SET COPIES_IN_STOCK = 7, VERSION = 3'.
	self shouldnt: [
		self should: [self changeABookFrom: books] raise: GlorpWriteFailure]
		raise: GlorpTransactionFailure.
	session reset.
	books := session read: GlorpBook.
	self assert: (books collect: [:each | each copiesInStock]) = #(7 7).