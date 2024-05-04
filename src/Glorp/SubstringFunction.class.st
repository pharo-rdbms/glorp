"
This is a function subclass specifically for substring functions. It needs its own separate subclass because it has to be written out differently for different databases, particularly if applied to LOB types. 
"
Class {
	#name : 'SubstringFunction',
	#superclass : 'PrefixFunction',
	#category : 'Glorp-Expressions',
	#package : 'Glorp',
	#tag : 'Expressions'
}

{ #category : 'preparing' }
SubstringFunction >> _rewriteFunctionArguments [
	"SUBSTR wants arguments position and length rather than (start) position and end position in Postgres, Oracle (not OracleODBC), MySQL, SQL Server and DB2."

	Halt now.
	base ultimateBaseExpression system platform usesLengthNotEndPosInSubstring
		ifTrue: [arguments last value: arguments last value - arguments first value + 1]
]

{ #category : 'printing' }
SubstringFunction >> printBasicSQLOn: aStream withParameters: aDictionary forSelect: aBoolean [

	^self ultimateBaseExpression system platform isPostgreSQLPlatform
		ifFalse: [ super printBasicSQLOn: aStream withParameters: aDictionary forSelect: aBoolean ]
		ifTrue: [
	aStream
		nextPutAll: function;
		nextPut: $(.
	aBoolean
		ifTrue: [base printSelectSQLOn: aStream withParameters: aDictionary]
		ifFalse: [base printSQLOn: aStream withParameters: aDictionary].
	aStream nextPutAll: ' from '.
	aBoolean
		ifTrue: [ (arguments at: 1) printSelectSQLOn: aStream withParameters: aDictionary]
		ifFalse: [ (arguments at: 1) printSQLOn: aStream withParameters: aDictionary].
	aStream nextPutAll: ' for '.
	aBoolean
		ifTrue: [ (arguments at: 2) printSelectSQLOn: aStream withParameters: aDictionary]
		ifFalse: [ (arguments at: 2) printSQLOn: aStream withParameters: aDictionary].
	aStream nextPut: $).
	alias notNil
		ifTrue:
			[aStream
				nextPutAll: ' AS ';
				nextPutAll: alias]]
]

{ #category : 'rewriting' }
SubstringFunction >> rewriteForOracleBlobsWith: mainArgument [
	"For Oracle blobs, we can't query with a normal substring function, but rather have to use the DBMS_LOB function, whose arguments are backwards. Further, we don't seem to be able to compare to byte-arrays, so turn it into a string."

	| oldBase template startPosition endPosition length |
	(mainArgument isGlorpExpression and: [mainArgument isConstantExpression]) ifFalse: [^self].
	function := 'UTL_RAW.CAST_TO_VARCHAR2'.
	startPosition := arguments first value.
	endPosition := arguments last value.
	length := arguments last value.
	arguments := #().
	oldBase := base.
	template := PrefixFunction named: 'DBMS_LOB.SUBSTR'.
	base := template createFor: (Array with: length asGlorpExpression with: startPosition asGlorpExpression) withBase: oldBase symbol: #dbmsLobSubstr
]

{ #category : 'rewriting' }
SubstringFunction >> rewriteForPostgresqlBase64BlobsWith: mainArgument [
	"This is pretty awful. We expect our main argument to be a string, and we're a substring function, but we know that for some types, the string representation comes out differently in the database. In particular, the Postgresql driver stores strings into lobs in Base64. So, if our previous argument = the string size, rewrite it to the database size. This makes it work if we do
    (someObject blob copyFrom: 1 to: 3) = 'abc'
when in fact, the length of that string in the blob will be 4."

	| base64Length |
	(mainArgument isGlorpExpression and: [mainArgument isConstantExpression]) ifFalse: [^self].
	self field type = self field platform blob ifFalse: [^self].
	(mainArgument value size \\ 3) = 0 ifFalse: [self error: 'Sorry, but you will need to use a number of characters that base64 encodes exactly'].
	base64Length := arguments second value + 1 - arguments first value.
	arguments at: 2 put: base64Length asGlorpExpression.
	mainArgument value: mainArgument value asByteArray
]

{ #category : 'preparing' }
SubstringFunction >> rewriteFunctionArgumentsWith: mainArgument [
	"This is pretty awful. We expect our main argument to be a string, and we're a substring function, but we know that for some types, the string representation comes out differently in the database. In particular, the Postgresql driver stores strings into lobs in Base64. So, if our previous argument = the string size, rewrite it to the database size. This makes it work if we do
    (someObject blob copyFrom: 1 to: 3) = 'abc'
when in fact, the length of that string in the blob will be 4."
	| platform |
	platform := base ultimateBaseExpression system platform.
	(platform class == PostgreSQLPlatform and: [self field type = platform blob]) ifTrue: [^self rewriteForPostgresqlBase64BlobsWith: mainArgument].
	(platform isOraclePlatform and: [self field type = platform blob]) ifTrue: [^self rewriteForOracleBlobsWith: mainArgument].
	"For MySQL and SQL Server, it wants position, length rather than startPosition, endPosition."
	(platform isMySQLPlatform or: [platform isSQLServerPlatform]) ifTrue: [arguments last value: (arguments last value - arguments first value + 1)]
]

{ #category : 'accessing' }
SubstringFunction >> type [

	^ self ultimateBaseExpression system platform varchar: 255
]
