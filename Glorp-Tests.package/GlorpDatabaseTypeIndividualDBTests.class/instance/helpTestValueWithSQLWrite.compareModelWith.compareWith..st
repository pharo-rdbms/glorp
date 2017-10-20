helpers
helpTestValueWithSQLWrite: anObject compareModelWith: modelBlock compareWith: aBlock
	| dbInValue readObject row converter dbOutValue typeTestModel system dbInValue2 readObject2 command |
	system := self systemFor: table.
	session system: system.
	row := DatabaseRow newForTable: table.
	row owner: GlorpTypeTestsModelClass new.
	converter := type
		converterForStType:
			(stType isNil
				ifTrue: [ anObject class ]
				ifFalse: [ stType ]).
	dbOutValue := converter convert: anObject toDatabaseRepresentationAs: type.
	row atFieldNamed: 'test' put: dbOutValue.
	self
		inTransactionDo: [ session writeRow: row.
			command := SQLStringCommand new setSQLString: 'SELECT test, id FROM ' , self tableName.
			command
				maximumLobSizeToRetrieveDirectly:
					((dbOutValue class = ByteArray or: [ dbOutValue isString ])
						ifTrue: [ dbOutValue size ]
						ifFalse: [ 42 ]).
			dbInValue := (session accessor executeCommand: command) first atIndex: 1.
			readObject := converter convert: dbInValue fromDatabaseRepresentationAs: type.
			(session platform canUseInWhereClause: dbOutValue type: type)
				ifTrue: [ dbInValue2 := self helpTestExplicitReadBackFor: dbOutValue.
					readObject2 := converter convert: dbInValue2 fromDatabaseRepresentationAs: type ].
			(session platform canUseInWhereClause: anObject type: type)
				ifTrue: [ typeTestModel := self readBackModelWithValue: anObject.
					self assert: (modelBlock value: typeTestModel value: anObject) ] ].
	self assert: (aBlock value: readObject value: anObject).
	readObject2 isNil
		ifFalse: [ self assert: (aBlock value: readObject2 value: anObject) ]