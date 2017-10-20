descriptors
descriptorForGlorpBookstoreCustomer: aDescriptor

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