examples
example2
	"Return an example start set of books, customers and orders."

	| book1 book2 book3 book4 customer1 customer2 |
	book1 := GlorpBook example1.
	book2 := GlorpBook example2.
	book3 := GlorpBook example3.
	book4 := GlorpBook example4.
	customer1 := self customerExample1.
	customer2 := self customerExample2.
	customer1 booksOnOrder: (Array with: book1 with: book3).
	customer2 booksOnOrder: (Array with: book2 with: book4).
	^OrderedCollection new
		add: book1;
		add: book2;
		add: book3;
		add: book4;
		add: customer1;
		add: customer2;
		yourself
		.