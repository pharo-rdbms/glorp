Class {
	#name : #GlorpDatabaseLoginResource,
	#superclass : #TestResource,
	#instVars : [
		'accessor',
		'login'
	],
	#classVars : [
		'DefaultLogin'
	],
	#category : #'Glorp-Tests-Database'
}

{ #category : #defaults }
GlorpDatabaseLoginResource class >> defaultLogin [
	"Return the default Login. Whether it binds is determined by UseBindingIfSupported if that is set, otherwise by the login platform's preference."

	DefaultLogin isNil ifTrue: [^DefaultLogin := self defaultPostgreSQLLogin].
	DefaultLogin database useBinding: DefaultLogin database class useBindingIfSupported.
	^DefaultLogin
]

{ #category : #defaults }
GlorpDatabaseLoginResource class >> defaultLogin: aLogin [ 
	DefaultLogin := aLogin.
	self triggerEvent: #changedDefaultLogin
]

{ #category : #defaults }
GlorpDatabaseLoginResource class >> defaultMysqlLogin [
	"To set the default database login to MySQL, execute the following statement."
	"self defaultMysqlLogin."

	^DefaultLogin := (Login new
		database: MySQLPlatform new;
		host: 'localhost';
		port: '3306';
		databaseName: 'sodbxtest';
		username: 'sodbxtest';
		password: 'sodbxtest')
	

]

{ #category : #defaults }
GlorpDatabaseLoginResource class >> defaultOracleLiteLogin [
	"To set the default database login to Oracle, execute the following statement."
	"self defaultOracleLiteLogin."

	^DefaultLogin := (Login new)
		database: OraclePlatform new;
		username: 'System';
		password: 'password';
		connectString: 'odbc:polite'
]

{ #category : #defaults }
GlorpDatabaseLoginResource class >> defaultOracleLogin [
	"To set the default database login to Oracle, execute the following statement."
	"self defaultOracleLogin."

	^DefaultLogin := (Login new)
		database: OraclePlatform new;
		username: 'System';
		password: 'manager';
		connectString: ''
]

{ #category : #defaults }
GlorpDatabaseLoginResource class >> defaultOracleODBCLogin [
	"To set the default database login to Oracle, execute the following statement."
	"self defaultOracleODBCLogin."

	^DefaultLogin := (Login new)
		database: OracleODBCPlatform new;
		username: 'System';
		password: 'manager';
		connectString: 'oracle'
]

{ #category : #defaults }
GlorpDatabaseLoginResource class >> defaultPlatform [
	^self defaultLogin database.
]

{ #category : #defaults }
GlorpDatabaseLoginResource class >> defaultPostgreSQLLogin [
	"To set the default database login to  PostgreSQL protocol 2.0 via socket, execute the following statement."
	"self defaultPostgreSQLLogin."

	^DefaultLogin := (Login new)
		database: PostgreSQLPlatform new;
		username: 'postgres';
		password: 'secret';
		connectString: 'localhost_test'.
]

{ #category : #defaults }
GlorpDatabaseLoginResource class >> defaultSQLServerLogin [
	"To set the default database login for Dolphin, execute the following statement."
	"self defaultSQLServerLogin."

	^DefaultLogin := (Login new)
		database: SQLServerPlatform new;
		username: 'glorptest';
		password: 'password';
		connectString: 'glorptest'
]

{ #category : #defaults }
GlorpDatabaseLoginResource class >> defaultSQLiteLocalLogin [
	"To set the default database login to SQLite, change the connectString to an appropriate path and execute the following statement."
	"self defaultSQLiteLocalLogin."

	<loginType: 'sqlite3'>

	^DefaultLogin := (Login new)
		database: SQLite3Platform new;
		host: SmalltalkImage current imagePath asFileReference parent fullName, '/';
		port: '';
		username: '';
		password: '';
		databaseName: 'sodbxtest.db'.

]

{ #category : #accessing }
GlorpDatabaseLoginResource >> accessor [
	^accessor
]

{ #category : #accessing }
GlorpDatabaseLoginResource >> accessor: anObject [
	accessor := anObject
]

{ #category : #accessing }
GlorpDatabaseLoginResource >> login [
	^login
]

{ #category : #accessing }
GlorpDatabaseLoginResource >> login: anObject [
	"We don't attempt to be secure on logins being used for tests. Make sure we don't surprise someone by modifying the original instance."

	login := anObject copy.
	login secure: false.
]

{ #category : #accessing }
GlorpDatabaseLoginResource >> platform [
	^login database
]

{ #category : #'initialize/release' }
GlorpDatabaseLoginResource >> setUp [
	Transcript show: self class name asString, ' setUp'; cr.
	super setUp.
	self login: self class defaultLogin.
	accessor := DatabaseAccessor forLogin: login.
	accessor login.
]

{ #category : #'initialize/release' }
GlorpDatabaseLoginResource >> tearDown [

	Transcript show: self class name asString, ' tearDown'; cr.
	accessor notNil ifTrue: [[accessor logout] on: Dialect error do: [:ex | ]].
]
