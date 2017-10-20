types
varchar
	^self typeNamed: #varchar ifAbsentPut: [GlorpVarCharType new typeName: 'character varying'].