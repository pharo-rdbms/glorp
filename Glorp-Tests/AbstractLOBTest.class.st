Class {
	#name : #AbstractLOBTest,
	#superclass : #GlorpDatabaseTypeIndividualDBTests,
	#category : 'Glorp-Tests-DatabaseTypes'
}

{ #category : #private }
AbstractLOBTest >> adjustForMaximumSize: aValue [
	^aValue ifNotNil: [ 	aValue size > session platform maximumQueryValueSize 
		ifTrue: [(aValue copyFrom: 1 to: session platform maximumQueryValueSize - 2), '%']
		ifFalse: [aValue]]
]

{ #category : #private }
AbstractLOBTest >> convertToTypeFrom: anObject [
	"For SQL-Server, return the function which converts anObject's value to my type."
	
	^anObject
		ifNotNil:
			[FunctionExpression for: #convertTo: withArguments: (Array with: anObject asGlorpExpression) basedOn: type asGlorpExpression system: session system]
]

{ #category : #private }
AbstractLOBTest >> helpTestExplicitReadBackFor: dbOutValue [
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
]

{ #category : #private }
AbstractLOBTest >> helpTestValue: anObject compareModelWith: modelBlock compareWith: aBlock [ 
	| dbOutValue |
	dbOutValue := self adjustForMaximumSize: anObject.
	^super helpTestValue: dbOutValue compareModelWith: modelBlock compareWith: aBlock.
]

{ #category : #private }
AbstractLOBTest >> readBackModelWithValue: anObject [
	"For SQL-Server, use CONVERT (which is easier than CAST for now), with = instead of LIKE."

	^ self useEqualityToCompare
		ifTrue: [ | converted |
			converted := self platform isSQLServerPlatform ifTrue: [ self convertToTypeFrom: anObject ] ifFalse: [ anObject ].
			session
				readOneOf: GlorpTypeTestsModelClass
				where: [ :each | each test = converted ] ]
		ifFalse: [ session
				readOneOf: GlorpTypeTestsModelClass
				where: [ :each | each test like: anObject ] ]

	"^session
		readOneOf: GlorpTypeTestsModelClass
		where: [:each | each test like: (Cast value: anObject as: type queryType)]."
]

{ #category : #private }
AbstractLOBTest >> useEqualityToCompare [
	^ self platform isSQLServerPlatform
		or: [ self platform isPostgreSQLPlatform ]
]
