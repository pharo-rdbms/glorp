"
This represents a prepared statement in the database. 

Instance Variables:
	busy	<Boolean>	Are we currently in use - that is to say, are we executing and/or holding an active cursor.
	signature	<String>	A string that we can use to match up to commands and see if we are appropriate for the command to use. The signature of a command is its SQL String plus a string representing the types of its parameters.
	statement	<Object>	The actual statement object. Because we don't really know what type this is, and it varies by dialect, we allow the accessor to extract it from us and do the real work.


"
Class {
	#name : #GlorpPreparedStatement,
	#superclass : #Object,
	#instVars : [
		'signature',
		'statement',
		'busy'
	],
	#category : #'Glorp-Database'
}

{ #category : #accessing }
GlorpPreparedStatement >> busy [

	^ busy
]

{ #category : #accessing }
GlorpPreparedStatement >> busy: aBoolean [

	busy := aBoolean
]

{ #category : #initialization }
GlorpPreparedStatement >> glorpNoticeOfExpiryIn: aSession [

	self release
]

{ #category : #initialization }
GlorpPreparedStatement >> initialize [
	super initialize.
	busy := false
]

{ #category : #initialization }
GlorpPreparedStatement >> release [

	super release.
	statement isNil ifFalse: [
		| stmt |
		stmt := statement.
		statement := nil.
		stmt disconnect ]
]

{ #category : #accessing }
GlorpPreparedStatement >> signature [

	^ signature
]

{ #category : #accessing }
GlorpPreparedStatement >> signature: aString [

	signature := aString
]

{ #category : #accessing }
GlorpPreparedStatement >> statement [

	^ statement
]

{ #category : #accessing }
GlorpPreparedStatement >> statement: aStatementHandle [

	statement := aStatementHandle
]
