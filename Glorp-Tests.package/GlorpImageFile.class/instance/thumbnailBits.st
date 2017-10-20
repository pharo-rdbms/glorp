testing
thumbnailBits
	thumbnailBits isNil ifTrue: [thumbnailBits := bits copyFrom: 1 to: 5].
	^thumbnailBits.