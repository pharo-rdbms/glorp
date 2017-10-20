helpers
helpTestExplicitReadBackFor: dbOutValue
	"Read back the row with the given value, using an explicit where clause."
	| queryStream result |
	queryStream := SQLStringSelectCommand sqlString: String new parameters: #() useBinding: false session: session.
	queryStream nextPutAll: 'SELECT test,id FROM ', self tableName, ' WHERE test '.
	queryStream nextPutAll: (dbOutValue isNil ifTrue: [' IS '] ifFalse: [' = ']).
	type print: dbOutValue on: queryStream.
	result := connection executeSQLString: queryStream contents.
	result isEmpty ifTrue: [^nil].
	^(result atIndex: 1) atIndex: 1.