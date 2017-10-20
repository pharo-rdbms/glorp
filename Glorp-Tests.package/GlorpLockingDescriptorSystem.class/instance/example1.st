examples
example1
	"Return an example start set of books, customers and orders."

	| cust1 cust2 book1 book2 |
	cust1 := self customerExample1.
	cust2 := self customerExample2.
	book1 := self bookExample1.
	book2 := self bookExample2.
	^Array
		with: book1
		with: book2
		with: cust1
		with: cust2.