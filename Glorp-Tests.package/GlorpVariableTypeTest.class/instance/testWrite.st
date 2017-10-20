testing
testWrite
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