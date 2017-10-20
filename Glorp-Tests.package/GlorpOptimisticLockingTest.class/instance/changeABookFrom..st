tests
changeABookFrom: books
	^session
		transact:
			[session register: books.
			books first copiesInStock: books first copiesInStock - 1].