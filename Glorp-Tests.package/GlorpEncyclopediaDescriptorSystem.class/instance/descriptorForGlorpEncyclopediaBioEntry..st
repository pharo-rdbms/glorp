descriptors
descriptorForGlorpEncyclopediaBioEntry: aDescriptor 
	| entryTable |
	entryTable := self tableNamed: 'ENCYC_BIO'.
	aDescriptor table: entryTable.
	"It's important that we have a mapping for the owner here, because we're expecting these entries to be deleted, and we can't delete them without knowing the primary keys."
	(aDescriptor newMapping: OneToOneMapping)
		attributeName: #owner;
		beReadOnly.
	(aDescriptor newMapping: DirectMapping) from: #title
		to: (entryTable fieldNamed: 'TITLE').
	(aDescriptor newMapping: DirectMapping) from: #text
		to: (entryTable fieldNamed: 'ENTRY_TEXT').