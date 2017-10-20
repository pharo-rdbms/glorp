types
blob
	"Return the MySQL type for long blob."
	^self typeNamed: #blob ifAbsentPut: [GlorpBlobType new typeString: 'LONGBLOB'].