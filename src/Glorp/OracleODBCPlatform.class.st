"
This is a platform for Oracle, as accessed through ODBC. The database doesn't change, but at least in VW we determine which connection type to use based on the platform object, so we need to use an ODBC connection rather than an OCI connection.
"
Class {
	#name : #OracleODBCPlatform,
	#superclass : #OraclePlatform,
	#category : 'Glorp-Platforms'
}

{ #category : #testing }
OracleODBCPlatform >> isODBCPlatform [

	^true.
]

{ #category : #testing }
OracleODBCPlatform >> usesLengthNotEndPosInSubstring [
	^false
]
