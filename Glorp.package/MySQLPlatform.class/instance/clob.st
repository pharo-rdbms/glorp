types
clob
	"Return the MySQL type for long text."
	^self typeNamed: #clob ifAbsentPut: [GlorpMySQLClobType new typeString: 'LONGTEXT'].