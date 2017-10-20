types
char
	^self typeNamed: #char ifAbsentPut: [GlorpCharType new typeName: 'character'].