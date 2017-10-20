classes
descriptorForGlorpGallery: aDescriptor
	
	| table linkTable imagesConditional |
	table := self tableNamed: 'GALLERY'.
	linkTable := self tableNamed: 'GALLERY_LINK'.
	aDescriptor table: table.
	aDescriptor directMappingFor: #id.
	aDescriptor directMappingFor: #name.
	imagesConditional := (aDescriptor newMapping: ConditionalToManyMapping)
		attributeName: #images;
		join: Join new.
	imagesConditional
		forField: (linkTable fieldNamed: 'LARGE')
		attribute: [:object | object isLarge]
		if: [:x | x = true]
		useMapping:
			((imagesConditional newMapping: ToManyMapping)
				attributeName: #imagesLink;
				useLinkTable;
				join:
						(Join
								from: (table fieldNamed: 'ID')
								to: (linkTable fieldNamed: 'GALLERY_ID')
								from: 'T'
								to: (linkTable fieldNamed: 'LARGE'))).
	imagesConditional
		otherwise:
			((imagesConditional newMapping: ToManyMapping)
				attributeName: #images;
				useLinkTable;
				join:
						(Join
								from: (table fieldNamed: 'ID')
								to: (linkTable fieldNamed: 'GALLERY_ID')
								from: 'F'
								to: (linkTable fieldNamed: 'LARGE'))).