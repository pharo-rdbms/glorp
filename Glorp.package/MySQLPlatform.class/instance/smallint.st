types
smallint

	^self typeNamed: #smallint ifAbsentPut: [GlorpSmallIntType new typeString: 'SMALLINT'].