"
This exercises trying to map to objects that might be of multiple types, not related by inheritance. 
"
Class {
	#name : #GlorpVariableTypeTest,
	#superclass : #GlorpMappingDBTest,
	#category : #'Glorp-Integration-Tests-Database'
}

{ #category : #Running }
GlorpVariableTypeTest >> setUp [
	super setUp.
	system := GlorpVariableTypeTestSystem forPlatform: session system platform.
	session system: system.
]

{ #category : #testing }
GlorpVariableTypeTest >> testRead [
	| gallery image |
	self inTransactionDo: [
		gallery := GlorpGallery new name: 'Some Gallery'.
		gallery images add: (GlorpImageFile example1).
		session modify: gallery in: [].
		session reset.
		gallery := session readOneOf: GlorpGallery.
		self assert: gallery images size = 1.
		image := gallery images first.
		self assert: image class = GlorpImageFile.
		self assert: image bits = GlorpImageFile example1 bits.
		].
]

{ #category : #testing }
GlorpVariableTypeTest >> testReadBoth [
	| gallery image link |
	self inTransactionDo: [
		gallery := GlorpGallery new name: 'Some Gallery'.
		gallery images add: (GlorpImageFile example2); add: (GlorpImageFile example1).
		session modify: gallery in: [].
		session reset.
		gallery := session readOneOf: GlorpGallery.
		self assert: gallery images size = 2.
		self assert: (gallery images select: [:each | each class = GlorpImageFile]) size = 1.
		image := gallery images detect: [:each | each class = GlorpImageFile].
		link := gallery images detect: [:each | each class = GlorpImageLink].
		self assert: (gallery images collect: [:each | each id]) asSet size = 2.
		self assert: image bits = (GlorpImageFile example1 bits).
		self assert: image thumbnailBits = (GlorpImageFile example1 bits).
		self assert: image thumbnailBits = (GlorpImageFile example2 thumbnailBits).


		].
]

{ #category : #testing }
GlorpVariableTypeTest >> testReadLarge [
	| gallery image |
	self inTransactionDo: [
		gallery := GlorpGallery new name: 'Some Gallery'.
		gallery images add: (GlorpImageFile example2).
		session modify: gallery in: [].
		session reset.
		gallery := session readOneOf: GlorpGallery.
		self assert: gallery images size = 1.
		image := gallery images first.
		self assert: image class = GlorpImageLink.
		self assert: image thumbnailBits = (GlorpImageFile example2 thumbnailBits) .
		].
]

{ #category : #testing }
GlorpVariableTypeTest >> testWrite [
	| gallery images links |
	self inTransactionDo: [
		gallery := GlorpGallery new name: 'Some Gallery'.
		gallery images add: (GlorpImageFile example1).
		session modify: gallery in: [].
		session reset.
		images := session accessor executeSQLString: 'SELECT * FROM GLORP_IMAGE_FILE'.
		self assert: images size = 1.
		links := session accessor executeSQLString: 'SELECT GALLERY_ID, IMAGE_ID, LARGE FROM GALLERY_LINK'.
		self assert: links size = 1.
		self assert: links first last ='F'].
]

{ #category : #testing }
GlorpVariableTypeTest >> testWriteLarge [
	| gallery images links |
	self inTransactionDo: [
		gallery := GlorpGallery new name: 'Some Gallery'.
		gallery images add: (GlorpImageFile example2).
		session modify: gallery in: [].
		session reset.
		images := session accessor executeSQLString: 'SELECT * FROM GLORP_IMAGE_FILE'.
		self assert: images size = 1.
		links := session accessor executeSQLString: 'SELECT GALLERY_ID, IMAGE_ID, LARGE FROM GALLERY_LINK'.
		self assert: links size = 1.
		self assert: links first last = 'T'].
]
