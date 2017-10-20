types
raw
	^self typeNamed: #raw ifAbsentPut: [GlorpBlobType new typeString: 'raw'].