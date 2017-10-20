testing
testReadLarge
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