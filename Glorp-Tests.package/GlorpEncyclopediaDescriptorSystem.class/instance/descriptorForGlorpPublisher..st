descriptors
descriptorForGlorpPublisher: aDescriptor 
	| table titleTable titleStockTable linkTable |
	table := self tableNamed: 'GR_PUBLISHER'.
	titleTable := self tableNamed: 'PUBLISHER_TITLE'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping) from: #id
		to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping) from: #name
		to: (table fieldNamed: 'NAME').
	(aDescriptor newMapping: DirectToManyMapping)
		attributeName: #titles;
		resultField: (titleTable fieldNamed: 'TITLE');
		writeTheOrderField;
		orderBy: [:each | (each getTable: titleTable) getField: 'POSITION'];
		join: (Join from: (table fieldNamed: 'ID') to: (titleTable fieldNamed: 'PUBLISHER_ID')).
	titleStockTable := self tableNamed: 'PUB_TITLES_STOCK'.
	(aDescriptor newMapping: DictionaryMapping)
		attributeName: #titlesWithNumberInStock;
		usesLinkTable: false;
		keyField: (titleStockTable fieldNamed: 'TITLE');
		valueField: (titleStockTable fieldNamed: 'STOCK');
		join: (Join from: (table fieldNamed: 'ID') to: (titleStockTable fieldNamed: 'PUBLISHER_ID')).
	linkTable := self tableNamed: 'PUB_EMP_LINK'.
	(aDescriptor newMapping: DictionaryMapping)
		attributeName: #employees;
		usesLinkTable: true;
		keyField: ((self tableNamed: 'PUBLISHER_EMP' ) fieldNamed: 'JOBTITLE');
		join: (Join 
			from: (table fieldNamed: 'ID')
			to: (linkTable fieldNamed: 'PUBLISHER_ID')
			from: 'A'
			to: (linkTable fieldNamed: 'FOO')).
	(aDescriptor newMapping: DictionaryMapping)
		attributeName: #differentBunchOfEmployeesById;
		usesLinkTable: true;
		join: (Join 
			from: (table fieldNamed: 'ID')
			to: (linkTable fieldNamed: 'PUBLISHER_ID')
			from: 'B'
			to: (linkTable fieldNamed: 'FOO'));
		keyField: ((self tableNamed: 'PUB_EMP_LINK') fieldNamed: 'EMP_ID').
		
"	titleStockLinkTable := self tableNamed: 'PUB_TITLE_LINK'.
	titleTable2 := self tableNamed: 'PUBLISHER_TITLE2'.
	(aDescriptor newMapping: DictionaryMapping)
		attributeName: #titlesWithNumberInStockLink;
		usesLinkTable: true;
		keyField: (titleTable2 fieldNamed: 'TITLE');
		valueField: (titleStockLinkTable fieldNamed: 'STOCK');
		linkTableJoin: (Join from: (table fieldNamed: 'ID') to: (titleStockLinkTable fieldNamed: 'PUBLISHER_ID'))."