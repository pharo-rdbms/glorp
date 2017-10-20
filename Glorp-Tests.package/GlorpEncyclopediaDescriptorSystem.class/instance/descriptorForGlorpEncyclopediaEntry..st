descriptors
descriptorForGlorpEncyclopediaEntry: aDescriptor 
	| entryTable |
	entryTable := self tableNamed: 'ENCYC_ENTRY'.
	aDescriptor table: entryTable.
	(aDescriptor newMapping: DirectMapping) from: #id
		to: (entryTable fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping) from: #title
		to: (entryTable fieldNamed: 'TITLE').
	(aDescriptor newMapping: DirectMapping) from: #text
		to: (entryTable fieldNamed: 'ENTRY_TEXT').
	(aDescriptor newMapping: EmbeddedValueOneToOneMapping)
		attributeName: #mediaType;
		referenceClass: GlorpMediaType;
		fieldTranslation: ((Join new)
					addSource: (entryTable fieldNamed: 'MEDIA_TYPE_NAME')
						target: ((self tableNamed: 'IMAGINARY_MEDIA_TYPE') 
								fieldNamed: 'MEDIA_TYPE_NAME');
					addSource: (entryTable fieldNamed: 'MEDIA_TYPE_MIME')
						target: ((self tableNamed: 'IMAGINARY_MEDIA_TYPE') 
								fieldNamed: 'MEDIA_TYPE_MIME');
					yourself).
	^aDescriptor