types
blob

	^self typeNamed: #blob ifAbsentPut: [GlorpBlobType new typeString: 'varbinary(max)'; queryType: (self varbinary)].