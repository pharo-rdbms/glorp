"
MSSQL  Sysname type 
"
Class {
	#name : 'GlorpMSSQLSysnameType',
	#superclass : 'GlorpDatabaseType',
	#category : 'Glorp-Types',
	#package : 'Glorp',
	#tag : 'Types'
}

{ #category : 'converting' }
GlorpMSSQLSysnameType >> impliedSmalltalkType [
	^String.
]

{ #category : 'testing' }
GlorpMSSQLSysnameType >> isStringType [
	^true.
]

{ #category : 'SQL' }
GlorpMSSQLSysnameType >> typeString [

	^'sysname'.
]
