testing
testReadBoth
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