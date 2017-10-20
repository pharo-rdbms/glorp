classes
classModelForGlorpImageFile: aClassModel
	aClassModel newAttributeNamed: #id.
	aClassModel newAttributeNamed: #title.
	aClassModel newAttributeNamed: #bits type: ByteArray.
	(aClassModel newAttributeNamed: #thumbnailBits type: ByteArray) useDirectAccess: false.