constants
sqlTextForDEFAULT: defaultValue
	"^<String>. Answer the column DEFAULT clause as a string with the given value.
	This is used in CREATE TABLE statements as part of each column specification."
	
	| strm |
	^defaultValue
		ifNotNil:
			[strm := String new writeStream.
			strm nextPutAll: 'DEFAULT '.
			defaultValue glorpPrintSQLOn: strm.
			strm contents]
		ifNil: ['']