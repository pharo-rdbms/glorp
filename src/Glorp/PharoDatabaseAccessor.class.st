"
A Database accessor for the Pharo platform

Instance Variables
	databaseDriver:		<Object>
	isInTransaction:		<Object>

databaseDriver
	- xxxxx

isInTransaction
	- xxxxx

"
Class {
	#name : #PharoDatabaseAccessor,
	#superclass : #DatabaseAccessor,
	#instVars : [
		'isInTransaction',
		'databaseDriver'
	],
	#classVars : [
		'DefaultDriver'
	],
	#category : #'Glorp-Core'
}

{ #category : #configuration }
PharoDatabaseAccessor class >> DefaultDriver [
	^DefaultDriver
]

{ #category : #configuration }
PharoDatabaseAccessor class >> DefaultDriver: aDriver [
	DefaultDriver := aDriver
]

{ #category : #executing }
PharoDatabaseAccessor >> basicExecuteSQLString: aString [
	^self databaseDriver basicExecuteSQLString: aString  
]

{ #category : #executing }
PharoDatabaseAccessor >> basicExecuteSQLString: aString binding: aBindingArray [
	^self databaseDriver basicExecuteSQLString: aString binding: aBindingArray 
]

{ #category : #executing }
PharoDatabaseAccessor >> basicExecuteSQLStringNoResult: aString doing: aBlock [

	| a |
	a := self basicExecuteSQLString: aString.
	aBlock value.
	^a
]

{ #category : #transactions }
PharoDatabaseAccessor >> beginTransaction [
	self log: 'Begin Transaction'.
	isInTransaction := true.
	self databaseDriver beginTransaction
]

{ #category : #transactions }
PharoDatabaseAccessor >> commitTransaction [
	self log: 'Commit Transaction'.
	isInTransaction := false.
	self databaseDriver commitTransaction
]

{ #category : #executing }
PharoDatabaseAccessor >> connection [
	self databaseDriver ifNil: [ ^nil ].
	^self databaseDriver connection
]

{ #category : #login }
PharoDatabaseAccessor >> connectionArgsFromCurrentLogin [

	"connect string looks like  hostname:portNumber_db-name. :portNumber is optional"
	| str portIndex index dbIndex |
	str := self currentLogin connectString.
	portIndex := index := str indexOf: $:.
	dbIndex := str indexOf: $_.
	index = 0 ifTrue: [index := dbIndex].
	^(Dialect smalltalkAt: #PGConnectionArgs)
		hostname: (str copyFrom: 1 to: index - 1)
		portno: (portIndex = 0 ifTrue: [5432] ifFalse: [(str copyFrom: portIndex + 1 to: dbIndex - 1) asNumber])
		databaseName: (str copyFrom: dbIndex + 1 to: str size)
		userName: self currentLogin username
		password: self currentLogin password
]

{ #category : #login }
PharoDatabaseAccessor >> connectionClassForLogin: aLogin [ 

	self class DefaultDriver ifNotNil: [ ^ self class DefaultDriver ].
	aLogin database class == MySQLPlatform 
		ifTrue: [ ^ Smalltalk at: #MySQLDatabaseDriver ].
	aLogin database class == PostgreSQLPlatform
		ifTrue: [ ^ Smalltalk at: #P3DatabaseDriver ].
	aLogin database class == UDBCSQLite3Platform 
		ifTrue: [ ^ Smalltalk at: #SQLite3Driver ].
	self error: 'A driver is not installed for platform: ' , aLogin database class name
]

{ #category : #login }
PharoDatabaseAccessor >> databaseDriver [
	^ databaseDriver
]

{ #category : #login }
PharoDatabaseAccessor >> databaseDriver: aDriver [
	databaseDriver := aDriver
]

{ #category : #executing }
PharoDatabaseAccessor >> disconnect [
	^ self connection disconnect
]

{ #category : #accessing }
PharoDatabaseAccessor >> encoding [
	 ^self connection queryEncoding
]

{ #category : #executing }
PharoDatabaseAccessor >> executeCommandBound: aCommand [
	| answerStream |
	self logCommand: aCommand bound: true.
	self useBinding ifFalse: [ ^ self executeCommandUnbound: aCommand  ].
	
	answerStream := self databaseDriver 
									basicExecuteSQLString: aCommand sqlString 
									binding: aCommand bindings.
									
	^ self cursorFor: answerStream command: aCommand.
	
]

{ #category : #executing }
PharoDatabaseAccessor >> executeCommandUnbound: aCommand [
	| answerStream |
	self log: aCommand sqlString.
	answerStream := self basicExecuteSQLString: aCommand sqlString.
	^self cursorFor: answerStream command: aCommand.
]

{ #category : #executing }
PharoDatabaseAccessor >> externalDatabaseErrorSignal [
	^ Dialect error
]

{ #category : #initialization }
PharoDatabaseAccessor >> initialize [
	super initialize.
	reusePreparedStatements := false.
	isInTransaction := false.
	logging := false "Set to true to see Glorp's SQL transcript."
]

{ #category : #executing }
PharoDatabaseAccessor >> innerExceptionFor: exception [
	"I don't know how to get the inner error in Squeak"
	^exception messageText.
]

{ #category : #transactions }
PharoDatabaseAccessor >> isInTransaction [
	^ isInTransaction
]

{ #category : #login }
PharoDatabaseAccessor >> isLoggedIn [
	self databaseDriver ifNil: [^ false].
	^ self databaseDriver isConnected
]

{ #category : #login }
PharoDatabaseAccessor >> loginIfError: aBlock [
	self log: 'Login'.
	self databaseDriver: self connectionClass new.
	self
		execute: [ currentLogin isSSL
				ifTrue: [ self databaseDriver connectSSL: currentLogin ]
				ifFalse: [ self databaseDriver connect: currentLogin ].
			currentLogin secure
				ifTrue: [ currentLogin discardPassword ] ]
		ifError: aBlock.
	self log: 'Login finished'
]

{ #category : #login }
PharoDatabaseAccessor >> logout [
	self isLoggedIn ifFalse: [^self].
	self log: 'Logout'.
	self databaseDriver logout.
	self log: 'Logout finished'
]

{ #category : #executing }
PharoDatabaseAccessor >> releaseCursor: aCursor in: aPreparedStatement [
	"Release the cursor. We're trapping exceptions, so return true or false to indicate success/failure"
	aCursor isNil ifTrue: [^self].
	^[aCursor close. true] on: Dialect error do: [:ex | ex return: false].
]

{ #category : #transactions }
PharoDatabaseAccessor >> rollbackTransaction [
	self log: 'Rollback Transaction'.
	isInTransaction := false.
	self databaseDriver rollbackTransaction
]

{ #category : #executing }
PharoDatabaseAccessor >> rowCount [
	^ self databaseDriver rowCount.
]

{ #category : #login }
PharoDatabaseAccessor >> showDialog: aString [ 
	UIManager default inform: aString
]
