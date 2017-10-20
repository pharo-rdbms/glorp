private
helpTestExplicitReadBackFor: dbOutValue
	"Read back the row with the given value, using an explicit where clause."
	| queryStream result compareClause|
	queryStream := SQLStringSelectCommand sqlString: nil parameters: #() useBinding: session useBinding session: session.
	queryStream nextPutAll: 'SELECT test,id FROM ', self tableName, ' WHERE test'.
	compareClause := ' = '. "self platform isSQLServerPlatform ifTrue: [' = '] ifFalse: [' LIKE ']."
	queryStream nextPutAll: (dbOutValue isNil ifTrue: [' IS '] ifFalse: [compareClause]).
	(dbOutValue notNil and: [type requiresCast]) ifTrue: [queryStream nextPutAll: ' CAST ('].
	(self platform isSQLServerPlatform and: [dbOutValue notNil and: [type requiresConvertToVarbinary]])
		ifTrue: [queryStream nextPutAll: ' CONVERT(varbinary(max),'].
	(queryStream canBind: dbOutValue to: type) 
		ifTrue: [
			queryStream parameters: (Array with: dbOutValue).
			queryStream nextPutAll: '?']
		ifFalse: [type print: dbOutValue on: queryStream].
	(dbOutValue notNil and: [type requiresCast]) ifTrue: [
		queryStream nextPutAll: ' AS '.
		queryStream nextPutAll: type queryType typeName.
		queryStream nextPutAll: ')'].
	(self platform isSQLServerPlatform and: [dbOutValue notNil and: [type requiresConvertToVarbinary]])
		ifTrue: [queryStream nextPutAll: ')'].
	result := connection executeCommand: queryStream.
	result isEmpty ifTrue: [^nil].
	^(result atIndex: 1) atIndex: 1.