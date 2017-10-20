classes
classModelForGlorpGallery: aClassModel
	aClassModel newAttributeNamed: #id.
	aClassModel newAttributeNamed: #name.
	aClassModel newAttributeNamed: #images collectionOf: GlorpImageFile.
	"Not a real attribute, but used in our conditional mapping."
	aClassModel newAttributeNamed: #imagesLink collectionOf: GlorpImageLink.