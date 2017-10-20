testing
testRead
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