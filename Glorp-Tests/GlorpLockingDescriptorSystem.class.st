Class {
	#name : #GlorpLockingDescriptorSystem,
	#superclass : #GlorpTestDescriptorSystem,
	#category : 'Glorp-Tests-Models'
}

{ #category : #other }
GlorpLockingDescriptorSystem >> allTableNames [

	^#('BOOK' 'BOOK_CUSTOMER' 'CUSTOMER_BOOK_LINK').
]

{ #category : #examples }
GlorpLockingDescriptorSystem >> bookExample1 [
	^(GlorpBook new)
		title: 'Mastering ENVY/Developer';
		author: 'Knight/Pelrine/Cho';
		description:
				'Absolutely the best book written on ENVY/Developer by a set of authors all living on different continents';
		copiesInStock: 2000;
		version: 1.
]

{ #category : #examples }
GlorpLockingDescriptorSystem >> bookExample2 [
	^(GlorpBook new)
		title: 'The Bad Beginning';
		author: 'Lemony Snicket';
		description: 'Very fine description of the EJB standards process';
		copiesInStock: 3;
		version: 5.
]

{ #category : #other }
GlorpLockingDescriptorSystem >> constructAllClasses [
	^(super constructAllClasses) 
		add: GlorpBook;
		add: GlorpBookstoreCustomer;
		yourself.
]

{ #category : #examples }
GlorpLockingDescriptorSystem >> customerExample1 [
	^(GlorpBookstoreCustomer new)
		accountNumber: '123456789ABCDEF';
		name: 'Aunt Colof'.
]

{ #category : #examples }
GlorpLockingDescriptorSystem >> customerExample2 [
	^(GlorpBookstoreCustomer new)
		accountNumber: '7';
		name: 'Veronica Filbert Davidson'.
]

{ #category : #descriptors }
GlorpLockingDescriptorSystem >> descriptorForGlorpBook: aDescriptor [

	| table |
	table := self tableNamed: 'BOOK'.
	aDescriptor table: table.
	aDescriptor addMapping: (	
		DirectMapping from: #id to: (table fieldNamed: 'ID')).
	aDescriptor addMapping: (	
		DirectMapping from: #title to: (table fieldNamed: 'TITLE')).
	aDescriptor addMapping: (	
		DirectMapping from: #copiesInStock to: (table fieldNamed: 'COPIES_IN_STOCK')).
	aDescriptor addMapping: (	
		DirectMapping from: #version to: (table fieldNamed: 'VERSION')).
]

{ #category : #descriptors }
GlorpLockingDescriptorSystem >> descriptorForGlorpBookstoreCustomer: aDescriptor [

	| table |
	table := self tableNamed: 'BOOK_CUSTOMER'.
	aDescriptor table: table.
	aDescriptor addMapping: (	
		DirectMapping from: #accountNumber to: (table fieldNamed: 'ACCOUNT_NUMBER')).
	aDescriptor addMapping: (	
		DirectMapping from: #name to: (table fieldNamed: 'NAME')).
	aDescriptor addMapping: (	
		ManyToManyMapping new
			attributeName: #booksOnOrder;
			referenceClass: GlorpBook).
]

{ #category : #examples }
GlorpLockingDescriptorSystem >> example1 [
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
]

{ #category : #examples }
GlorpLockingDescriptorSystem >> example2 [
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
]

{ #category : #tables }
GlorpLockingDescriptorSystem >> tableForBOOK: aTable [

	(aTable createFieldNamed: 'ID' type: platform serial) bePrimaryKey.
	aTable createFieldNamed: 'TITLE' type: (platform varChar: 100).
	aTable createFieldNamed: 'DESCRIPTION' type: (platform varChar: 255).
	aTable createFieldNamed: 'COPIES_IN_STOCK' type: (platform int4).
	(aTable createFieldNamed: 'VERSION' type: (platform versionFieldFor: platform int4)) beLockKey.
]

{ #category : #tables }
GlorpLockingDescriptorSystem >> tableForBOOK_CUSTOMER: aTable [

	(aTable createFieldNamed: 'ACCOUNT_NUMBER' type: (platform varChar: 15)) bePrimaryKey.
	aTable createFieldNamed: 'NAME' type: (platform varChar: 100).
]

{ #category : #tables }
GlorpLockingDescriptorSystem >> tableForCUSTOMER_BOOK_LINK: aTable [

	| custKey bookKey |
	custKey := aTable createFieldNamed: 'CUSTOMER_ACCT_NUM' type: (platform varChar: 15).
	aTable addForeignKeyFrom: custKey
		to: ((self tableNamed: 'BOOK_CUSTOMER') fieldNamed: 'ACCOUNT_NUMBER').
	bookKey := aTable createFieldNamed: 'BOOK_ID' type: (platform int4).
		aTable addForeignKeyFrom: bookKey
		to: ((self tableNamed: 'BOOK') fieldNamed: 'ID').
]
