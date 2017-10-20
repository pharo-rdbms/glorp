descriptors
descriptorForGlorpTinyPublisher: aDescriptor 
	| table titleStockTable |
	table := self tableNamed: 'GR_TINY_PUBLISHER'.

	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping) from: #id
		to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping) from: #name
		to: (table fieldNamed: 'NAME').

	titleStockTable := self tableNamed: 'PU2B_TITLES_STOCK'.
	(aDescriptor newMapping: DictionaryMapping)
		attributeName: #titlesWithNumberInStock;
		usesLinkTable: false;
		keyField: (titleStockTable fieldNamed: 'TITLE');
		valueField: (titleStockTable fieldNamed: 'STOCK');
		join: (Join from: (table fieldNamed: 'ID') to: (titleStockTable fieldNamed: 'TINY_PUBLISHER_ID')).