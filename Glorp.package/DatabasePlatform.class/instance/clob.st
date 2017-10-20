types
clob
	^self typeNamed: #blob ifAbsentPut: [GlorpClobType new].