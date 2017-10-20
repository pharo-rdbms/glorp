types
clob

	^self typeNamed: #clob ifAbsentPut: [GlorpClobType new typeString: 'clob'].