classes
descriptorForGlorpImageFile: aDescriptor
	
	aDescriptor table: 'GLORP_IMAGE_FILE'.
	aDescriptor directMappingFor: #id.
	aDescriptor directMappingFor: #title.
	aDescriptor directMappingFor: #bits.
	aDescriptor directMapping from: #thumbnailBits to: 'THUMBNAIL_BITS'.