support
writeTestHarnessForTags

	| tag1 tag2 tag3 image1 image2 |
	session inUnitOfWorkDo: [
		tag1 := GlorpTag new label: 'First'; generateKeyFromLabel.
		tag2 := GlorpTag new label: 'Second'; generateKeyFromLabel.
		tag3 := GlorpTag new label: 'Third'; generateKeyFromLabel.

		image1 := GlorpImage new location: 'testlocation'.
		session register: image1.
	
		image1 tags add: tag1.
		image1 tags add: tag2.
	
		image2 := GlorpImage new location: 'testlocation2'.
		session register: image2.
	
		image2 tags add: tag2.
		image2 tags add: tag3].
	session reset.