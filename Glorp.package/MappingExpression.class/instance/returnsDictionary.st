testing
returnsDictionary
	"Return true if we representa  ampping to a dictionary"
	^self mapping isToManyRelationship and: [self mapping collectionType == Dictionary].