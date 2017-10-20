classes
descriptorForGlorpImageLink: aDescriptor
	
	aDescriptor table: 'GLORP_IMAGE_FILE'.
	aDescriptor directMappingFor: #id.
	aDescriptor directMappingFor: #title.
	aDescriptor directMapping from: #thumbnailBits to: 'THUMBNAIL_BITS'.
	"This is really joining to our own table to get the full version of ourselves"
	aDescriptor oneToOneMapping 
		attributeName: #fullImage;
		join: (Join from: (aDescriptor table fieldNamed: 'ID') to: (aDescriptor table fieldNamed: 'ID')).