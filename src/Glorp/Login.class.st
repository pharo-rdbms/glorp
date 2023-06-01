"
Enough information to log in to a particular database.

Instance Variables:
	connectString	<String>	The string that will be passed to the driver level to tell us what to connect to. This might be e.g. an ODBC data source name, or it might be a host name plus socket/database name for Postgresql.
	database	<DatabasePlatform>	The platform describing what type of database this is. Used here mostly to indicate how we need to talk to the underlying connection layer, which may be different by database.
	name	<String>	A name we can use to describe this. No significance to the database.
	password	<String>	The connect password.
	schema	<String>	What should our default schema be. Used mostly internally, to set the schema of the tables we are using.
	username	<String>	The connect username.


"
Class {
	#name : #Login,
	#superclass : #Object,
	#instVars : [
		'encodingStrategy',
		'database',
		'username',
		'password',
		'connectString',
		'name',
		'schema',
		'databaseName',
		'host',
		'port',
		'secure',
		'settings'
	],
	#category : #'Glorp-Core'
}

{ #category : #'instance creation' }
Login class >> new [

	^ super new initialize
]

{ #category : #comparing }
Login >> = aLogin [

	^ self class == aLogin class and: [
		  self name = aLogin name and: [
			  self database class = aLogin database class and: [
				  self username = aLogin username and: [
					  self connectString = aLogin connectString ] ] ] ]
]

{ #category : #converting }
Login >> asGlorpLogin [
	"Polymorph with objects that know how to convert themselves to Logins, e.g. Store ConnectionProfiles."

	^ self
]

{ #category : #accessing }
Login >> connectString [

	^ connectString
]

{ #category : #accessing }
Login >> connectString: aString [

	connectString := aString
]

{ #category : #accessing }
Login >> database [

	^ database
]

{ #category : #accessing }
Login >> database: aDatabasePlatform [

	database := aDatabasePlatform
]

{ #category : #accessing }
Login >> databaseName [
	"connect string looks like hostname:portNumber_db-name.
	:portNumber is optional"
	
	| str portIndex index dbIndex |
	
	databaseName == nil
		ifFalse: [^ databaseName].
	databaseName == nil
		ifTrue: [str := self connectString.
			portIndex := index := str indexOf: $:.
			dbIndex := str indexOf: $_.
			index = 0
				ifTrue: [index := dbIndex].
			databaseName := str copyFrom: dbIndex + 1 to: str size.
			^ databaseName]
]

{ #category : #accessing }
Login >> databaseName: aDatabaseName [

	databaseName := aDatabaseName
]

{ #category : #accessing }
Login >> discardPassword [

	password := nil
]

{ #category : #accessing }
Login >> encodingStrategy [

	^ encodingStrategy
]

{ #category : #accessing }
Login >> encodingStrategy: anEncodingStrategy [

	encodingStrategy := anEncodingStrategy
]

{ #category : #accessing }
Login >> hash [

	^ self name hash + self database class hash + self username hash
	  + self connectString hash
]

{ #category : #accessing }
Login >> host [
	"connect string looks like hostname:portNumber_db-name.
	:portNumber is optional"
	| str portIndex index dbIndex |
	host == nil
		ifFalse: [^ host].
	host == nil
		ifTrue: [str := self connectString.
			portIndex := index := str indexOf: $:.
			dbIndex := str indexOf: $_.
			index = 0 ifTrue: [index := dbIndex].
			host := index > 0
				ifTrue: [ str copyFrom: 1 to: index - 1 ].
			^ host]
]

{ #category : #accessing }
Login >> host: aHost [

	host := aHost
]

{ #category : #initialization }
Login >> initialize [
	super initialize.
	settings := IdentityDictionary new.
	secure := false.
	schema := ''
]

{ #category : #testing }
Login >> isSSL [
	"Return true if my current connection is SSL encrypted"

	^ settings at: #ssl ifAbsent: [ false ]
]

{ #category : #accessing }
Login >> name [

	name isNil
		ifTrue: [ ^ self connectString ]
		ifFalse: [ ^ name ]
]

{ #category : #accessing }
Login >> name: aString [

	name := aString
]

{ #category : #accessing }
Login >> password [
	"Return the password for this login. If we are in a secure mode, then erase the password as soon as it is accessed."

	| returnValue |
	returnValue := password.
	secure ifTrue: [ password := nil ].
	^ returnValue
]

{ #category : #accessing }
Login >> password: aString [

	password := aString
]

{ #category : #accessing }
Login >> platform [

	^ self database
]

{ #category : #accessing }
Login >> port [
	"connect string looks like hostname:portNumber_db-name.
	:portNumber is optional"
	| str portIndex index dbIndex |
	port == nil
		ifFalse: [^ port].
	port == nil
		ifTrue: [str := self connectString.
			portIndex := index := str indexOf: $:.
			dbIndex := str indexOf: $_.
			index = 0
				ifTrue: [index := dbIndex].
			port := portIndex = 0
						ifTrue: [self platform defaultPort asString]
						ifFalse: [(str copyFrom: portIndex + 1 to: dbIndex - 1) asString].
			^ port]
]

{ #category : #accessing }
Login >> port: aPort [

	port := aPort
]

{ #category : #printing }
Login >> printOn: aStream [

	aStream nextPutAll: 'a Login('.
	database printOn: aStream.
	aStream nextPutAll: ', '.
	username printOn: aStream.
	aStream nextPutAll: ', '.
	connectString printOn: aStream.
	aStream nextPutAll: ', '.
	schema printOn: aStream.
	aStream nextPutAll: ')'
]

{ #category : #accessing }
Login >> schema [

	^ schema
]

{ #category : #accessing }
Login >> schema: aString [

	schema := aString
]

{ #category : #accessing }
Login >> secure [

	^ secure
]

{ #category : #accessing }
Login >> secure: aBoolean [

	secure := aBoolean
]

{ #category : #'session creation' }
Login >> sessionForDescriptorSystem: aDescriptorSystemClass [
	"Create a session for this login, using aDescriptorSystemClass for its metadata"

	^ aDescriptorSystemClass sessionForLogin: self
]

{ #category : #initialization }
Login >> setSSL [

	settings at: #ssl put: true
]

{ #category : #accessing }
Login >> username [

	^ username
]

{ #category : #accessing }
Login >> username: aString [

	username := aString
]
