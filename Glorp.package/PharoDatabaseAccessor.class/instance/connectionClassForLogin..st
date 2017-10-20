login
connectionClassForLogin: aLogin 

	self class DefaultDriver ifNotNil: [ ^ self class DefaultDriver ].
	aLogin database class == PostgreSQLPlatform
		ifTrue: [ ^ Smalltalk at: #NativePostgresDriver ].
	aLogin database class == UDBCSQLite3Platform 
		ifTrue: [ ^ Smalltalk at: #NBSQLite3GlorpAccessor ].
	self error: 'A driver is not installed for platform: ' , aLogin database class name