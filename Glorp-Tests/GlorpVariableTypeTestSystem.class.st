"
This is a system for testing variable relationships. That is, where we have a relationship that might be one type of object, or might be another, depending on some criteria. The objects are not related by inheritance. Our example is a relationship to images, where if the images are small we retrieve them directly, but if they are larger we only retrieve minimal information about them.3
"
Class {
	#name : #GlorpVariableTypeTestSystem,
	#superclass : #GlorpTestDescriptorSystem,
	#category : 'Glorp-Tests-Models'
}

{ #category : #classes }
GlorpVariableTypeTestSystem >> classModelForGlorpGallery: aClassModel [
	aClassModel newAttributeNamed: #id.
	aClassModel newAttributeNamed: #name.
	aClassModel newAttributeNamed: #images collectionOf: GlorpImageFile.
	"Not a real attribute, but used in our conditional mapping."
	aClassModel newAttributeNamed: #imagesLink collectionOf: GlorpImageLink.
]

{ #category : #classes }
GlorpVariableTypeTestSystem >> classModelForGlorpImageFile: aClassModel [
	aClassModel newAttributeNamed: #id.
	aClassModel newAttributeNamed: #title.
	aClassModel newAttributeNamed: #bits type: ByteArray.
	(aClassModel newAttributeNamed: #thumbnailBits type: ByteArray) useDirectAccess: false.
]

{ #category : #classes }
GlorpVariableTypeTestSystem >> classModelForGlorpImageLink: aClassModel [
	aClassModel newAttributeNamed: #id.
	aClassModel newAttributeNamed: #title.
	aClassModel newAttributeNamed: #thumbnailBits type: ByteArray.
	aClassModel newAttributeNamed: #fullImage type: GlorpImageFile.
]

{ #category : #classes }
GlorpVariableTypeTestSystem >> descriptorForGlorpGallery: aDescriptor [
	
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
]

{ #category : #classes }
GlorpVariableTypeTestSystem >> descriptorForGlorpImageFile: aDescriptor [
	
	aDescriptor table: 'GLORP_IMAGE_FILE'.
	aDescriptor directMappingFor: #id.
	aDescriptor directMappingFor: #title.
	aDescriptor directMappingFor: #bits.
	aDescriptor directMapping from: #thumbnailBits to: 'THUMBNAIL_BITS'.
]

{ #category : #classes }
GlorpVariableTypeTestSystem >> descriptorForGlorpImageLink: aDescriptor [
	
	aDescriptor table: 'GLORP_IMAGE_FILE'.
	aDescriptor directMappingFor: #id.
	aDescriptor directMappingFor: #title.
	aDescriptor directMapping from: #thumbnailBits to: 'THUMBNAIL_BITS'.
	"This is really joining to our own table to get the full version of ourselves"
	aDescriptor oneToOneMapping 
		attributeName: #fullImage;
		join: (Join from: (aDescriptor table fieldNamed: 'ID') to: (aDescriptor table fieldNamed: 'ID')).
]

{ #category : #classes }
GlorpVariableTypeTestSystem >> tableForGALLERY: aTable [
	aTable createFieldNamed: 'ID' type: platform serial.
	aTable createFieldNamed: 'NAME' type: platform text.
]

{ #category : #classes }
GlorpVariableTypeTestSystem >> tableForGALLERY_LINK: aTable [
	| galleryId imageId |
	galleryId := aTable createFieldNamed: 'GALLERY_ID' type: platform integer.
	aTable addForeignKeyFrom: galleryId to: ((self tableNamed: 'GALLERY') fieldNamed: 'ID').
	imageId := aTable createFieldNamed: 'IMAGE_ID' type: platform integer.
	aTable addForeignKeyFrom: imageId to: ((self tableNamed: 'GLORP_IMAGE_FILE') fieldNamed: 'ID').
	"Avoid booleans here because they aren't portable"
	aTable createFieldNamed: 'LARGE' type: (platform char: 1).
]

{ #category : #classes }
GlorpVariableTypeTestSystem >> tableForGLORP_IMAGE_FILE: aTable [
	aTable createFieldNamed: 'ID' type: platform serial.
	aTable createFieldNamed: 'TITLE' type: platform text.
	aTable createFieldNamed: 'BITS' type: platform blob.
	aTable createFieldNamed: 'THUMBNAIL_BITS' type: platform blob.
]
