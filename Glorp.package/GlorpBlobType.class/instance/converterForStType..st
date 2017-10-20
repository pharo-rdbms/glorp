types
converterForStType: aClass
	self platform isPostgreSQLPlatform ifTrue: [
		(aClass includesBehavior: String) ifTrue: [^self platform converterNamed: #stringToSQLString].
		^self platform converterNamed: #byteArrayToSQLString].
	self platform isOcelotPlatform ifTrue: [^self platform converterNamed: #blobDataToStream].
	(aClass includesBehavior: String) ifTrue: [^self platform converterNamed: #byteArrayToString].
	^self platform nullConverter