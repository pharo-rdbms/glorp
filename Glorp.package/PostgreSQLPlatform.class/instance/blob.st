types
blob

	^self typeNamed: #blob ifAbsentPut: [GlorpBlobType new typeString: 'bytea'].