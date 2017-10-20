types
varchar
	^self typeNamed: #varchar ifAbsentPut: [GlorpVarCharType new typeName: 'varchar2'].