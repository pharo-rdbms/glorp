Class {
	#name : #GlorpDatabaseTypeIndividualDBTests,
	#superclass : #GlorpTestCase,
	#instVars : [
		'type',
		'stType',
		'connection',
		'session',
		'table'
	],
	#category : 'Glorp-Tests-DatabaseTypes'
}

{ #category : #'as yet unclassified' }
GlorpDatabaseTypeIndividualDBTests class >> resources [
	^Array with: GlorpDatabaseLoginResource with: GlorpSessionResource.
]

{ #category : #helpers }
GlorpDatabaseTypeIndividualDBTests >> compareFloatInModel: read with: original [
	read isNil ifTrue: [^false].
	read test = original ifTrue: [^true].
	read test isNil ifTrue: [^false].
	^(read test - original) abs <= 0.00001.
]

{ #category : #setUp }
GlorpDatabaseTypeIndividualDBTests >> createTypeTestTable [
	| system |
	connection doDDLOperation: [
		connection
			dropTableNamed: self tableName
			ifAbsent: [:ex | ex return: nil].
		table := DatabaseTable named: self tableName.
		table
			createFieldNamed: 'test'
			type: type.
		(table createFieldNamed: 'id' type: session system platform inMemorySequence) bePrimaryKey.
		connection
			createTable: table
			ifError:
				[:ex | 
				Transcript show: 'CANNOT CREATE TABLE'.
             		self signalFailure: ex messageText.
				ex return: nil].
	].
	system := self systemFor: table.
	session system: system.
	^table.
]

{ #category : #setUp }
GlorpDatabaseTypeIndividualDBTests >> defaultDatabaseType [
	self subclassResponsibility.
]

{ #category : #helpers }
GlorpDatabaseTypeIndividualDBTests >> helpTestExplicitReadBackFor: dbOutValue [
	"Read back the row with the given value, using an explicit where clause."
	| queryStream result |
	queryStream := SQLStringSelectCommand sqlString: String new parameters: #() useBinding: false session: session.
	queryStream nextPutAll: 'SELECT test,id FROM ', self tableName, ' WHERE test '.
	queryStream nextPutAll: (dbOutValue isNil ifTrue: [' IS '] ifFalse: [' = ']).
	type print: dbOutValue on: queryStream.
	result := connection executeSQLString: queryStream contents.
	result isEmpty ifTrue: [^nil].
	^(result atIndex: 1) atIndex: 1.
]

{ #category : #helpers }
GlorpDatabaseTypeIndividualDBTests >> helpTestFloat: anObject [
	"Don't try and read back an equal float, it'll likely fail on precision issues"

	self
		helpTestValue: anObject
		compareModelWith:
			[:read :original | self compareFloatInModel: read with: original]
		compareWith:
			[:read :original | original isNil or: [(read - original) abs <= 0.00001]].
]

{ #category : #helpers }
GlorpDatabaseTypeIndividualDBTests >> helpTestInvalidValue: anObject [
	self helpTestValue: anObject
		compareModelWith: [:read :original | read isNil or: [ read test ~= original ]]
		compareWith: [:read :original | read ~= original]
]

{ #category : #helpers }
GlorpDatabaseTypeIndividualDBTests >> helpTestValue: anObject [ 
	"Don't try and read back an equal float, it'll likely fail on precision issues"

	self 
		helpTestValue: anObject
		compareModelWith: 
			[:read :original | 
			read notNil and: 
					[(original isKindOf: Float) or: 
							[original class == Dialect doublePrecisionFloatClass 
								or: [read test = original]]]]
		compareWith: [:read :original | read = original]
]

{ #category : #helpers }
GlorpDatabaseTypeIndividualDBTests >> helpTestValue: anObject compareModelWith: modelBlock compareWith: aBlock [ 
	self 
		helpTestValueWithSQLWrite: anObject
		compareModelWith: modelBlock
		compareWith: aBlock.
	self 
		helpTestValueWithUnitOfWorkWrite: anObject
		compareModelWith: modelBlock
]

{ #category : #helpers }
GlorpDatabaseTypeIndividualDBTests >> helpTestValue: anObject compareWith: aBlock [ 
	self 
		helpTestValue: anObject
		compareModelWith: [:read :original | true]
		compareWith: aBlock
]

{ #category : #helpers }
GlorpDatabaseTypeIndividualDBTests >> helpTestValueWithSQLWrite: anObject compareModelWith: modelBlock compareWith: aBlock [
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
]

{ #category : #helpers }
GlorpDatabaseTypeIndividualDBTests >> helpTestValueWithUnitOfWorkWrite: anObject compareModelWith: aBlock [
	| typeTestModel system model |
	system := self systemFor: table.
	session system: system.
	self inTransactionDo: [
	session beginUnitOfWork.
	model := GlorpTypeTestsModelClass new test: anObject.
	session register: model.
	session commitUnitOfWork.
	session reset.
	(session platform canUseInWhereClause: anObject type: type) ifTrue: [
		typeTestModel := self readBackModelWithValue: anObject.
		self assert: (aBlock value: typeTestModel value: anObject)]].
]

{ #category : #helpers }
GlorpDatabaseTypeIndividualDBTests >> inTransactionDo: aBlock [
	"Like the one in session, but always rollback."
	| alreadyInTransaction result |
	[ 
	alreadyInTransaction := session isInTransaction.
	alreadyInTransaction ifFalse: [session beginTransaction].
	result := aBlock numArgs = 1 ifTrue: [aBlock value: self] ifFalse: [aBlock value].
	alreadyInTransaction ifFalse: [session rollbackTransaction]]
		ifCurtailed:
			[alreadyInTransaction ifFalse: [session rollbackTransaction]].
	^result.
]

{ #category : #initializing }
GlorpDatabaseTypeIndividualDBTests >> initialize [
]

{ #category : #accessing }
GlorpDatabaseTypeIndividualDBTests >> platform [
	^connection platform
]

{ #category : #helpers }
GlorpDatabaseTypeIndividualDBTests >> readBackModelWithValue: anObject [
	^session
		readOneOf: GlorpTypeTestsModelClass
		where: [:each | each test = anObject].
]

{ #category : #setUp }
GlorpDatabaseTypeIndividualDBTests >> setUp [
	super setUp.
	session := GlorpSessionResource current newSession.
	connection := session accessor.
	type := self defaultDatabaseType.
	table := self createTypeTestTable.
]

{ #category : #setUp }
GlorpDatabaseTypeIndividualDBTests >> systemFor: aTable [
	| system descriptor mapping model |
	system := DynamicDescriptorSystem new.
	model := system addClassModelFor: GlorpTypeTestsModelClass.
	model newAttributeNamed: #id.
	model newAttributeNamed: #test type: stType.
	system privateTableAt: aTable name put: aTable.
	descriptor := Descriptor new.
	descriptor system: system.
	descriptor classModel: model.
	descriptor table: aTable.
	descriptor
		addMapping: (DirectMapping from: #id to: (aTable fieldNamed: 'id')).
	stType isNil
		ifTrue:
			[mapping := DirectMapping from: #test to: (aTable fieldNamed: 'test')]
		ifFalse:
			[mapping := DirectMapping
				from: #test
				type: stType
				to: (aTable fieldNamed: 'test')].
	descriptor addMapping: mapping.
	system privateDescriptorAt: GlorpTypeTestsModelClass put: descriptor.
	^system.
]

{ #category : #setUp }
GlorpDatabaseTypeIndividualDBTests >> tableName [
	^'TYPETESTS', self defaultDatabaseType selector.
]

{ #category : #setUp }
GlorpDatabaseTypeIndividualDBTests >> tearDown [
	super tearDown.
	session doDDLOperation: [
		connection
			dropTableNamed: self tableName
			ifAbsent: [:ex | ex return: nil]].
	session reset.
	session := nil.
]
