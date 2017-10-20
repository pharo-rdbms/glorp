types
clob

	^self typeNamed: #clob ifAbsentPut: [GlorpClobType new typeString: 'varchar(max)'].