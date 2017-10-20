types
text
	^self typeNamed: #nvarchar ifAbsentPut: [GlorpTextType new typeString: 'text']