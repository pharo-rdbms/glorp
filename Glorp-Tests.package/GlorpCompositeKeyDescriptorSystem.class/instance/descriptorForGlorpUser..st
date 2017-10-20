descriptors
descriptorForGlorpUser: aDescriptor

	| table folderMapping |
	table := self tableNamed: 'GR_USER'.
	aDescriptor table: table.

	aDescriptor addMapping: (DirectMapping from: #id to: (table fieldNamed: 'ID')).
	aDescriptor addMapping: (DirectMapping from: #name to: (table fieldNamed: 'NAME')).

	folderMapping := OneToManyMapping new
		attributeName: #folders;
		referenceClass: GlorpFolder.
"		mappingCriteria: 
						(Join
								from: (table fieldNamed: 'ID')
								to: (folderTable fieldNamed: 'USER_ID'))."
	folderMapping beExclusive.
	aDescriptor addMapping: folderMapping.