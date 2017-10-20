descriptors
descriptorForGlorpMediaType: aDescriptor 
	| table |
	table := self tableNamed: 'IMAGINARY_MEDIA_TYPE'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping) from: #name
		to: (table fieldNamed: 'MEDIA_TYPE_NAME').
	(aDescriptor newMapping: DirectMapping) from: #mimeType
		to: (table fieldNamed: 'MEDIA_TYPE_MIME')