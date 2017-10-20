descriptors
descriptorForGlorpTravelFolder: aDescriptor
	| table linkTable unorderedTable |
	table := self tableNamed: 'FOLDERS'.
	linkTable := self tableNamed: 'FOLDER_FILES_LINK'.
	unorderedTable := self tableNamed: 'UNORDERED_LINK'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping) from: #id
		to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping) from: #name
		to: (table fieldNamed: 'name').
	(aDescriptor toManyMapping)
		attributeName: #files;
		useLinkTable;
		orderBy: [:e | (e getTable: 'FOLDER_FILES_LINK') getField: 'cindex'];
		writeTheOrderField;
		join: (Join from: (table fieldNamed: 'ID')
					to: (linkTable fieldNamed: 'FOLDER_ID')).
	(aDescriptor toManyMapping)
		attributeName: #unordered;
		useLinkTable;
		join: (Join from: (table fieldNamed: 'ID')
					to: (unorderedTable fieldNamed: 'FOLDER_ID')).