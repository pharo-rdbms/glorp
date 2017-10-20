descriptors
descriptorForGlorpEncyclopedia: aDescriptor 
	| table linkTable |
	table := self tableNamed: 'ENCYC'.
	linkTable := self tableNamed: 'ENCYC_ENTRY_LINK'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping) from: #id
		to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping) from: #name
		to: (table fieldNamed: 'NAME').
	(aDescriptor newMapping: BasicDictionaryMapping)
		attributeName: #entries;
		referenceClass: GlorpEncyclopediaEntry;
		keyField: (linkTable fieldNamed: 'REFERENCE_NO');
		linkFields: (Array 
					with: (linkTable fieldNamed: 'ENCYC_ENTRY_ID')).
	(aDescriptor newMapping: DictionaryMapping)
		attributeName: #biographicalEntries;
		referenceClass: GlorpEncyclopediaBioEntry;
		usesLinkTable: false;
		beExclusive;
		keyField: ((self tableNamed: 'ENCYC_BIO') fieldNamed: 'TITLE').