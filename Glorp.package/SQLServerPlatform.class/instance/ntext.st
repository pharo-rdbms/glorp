types
ntext
	^self typeNamed: #ntext ifAbsentPut: [GlorpClobType new typeString: 'ntext']