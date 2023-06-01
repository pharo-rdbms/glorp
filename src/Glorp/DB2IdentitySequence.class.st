"
DB2IdentitySequence is the sequence class for DB2 identity columns. Glorp prefers sequence objects over identity columns, and although DB2 has both, Glorp defaults to using sequences. Therefore there is no code here to create an identity column. Primary keys will use sequences instead. DB2IdentitySequence primarily helps in the analysis of tables that were created outside Glorp.

One can obtain the most recently installed number using a query like this.
	VALUES IDENTITY_VAL_LOCAL().

"
Class {
	#name : #DB2IdentitySequence,
	#superclass : #NamedSequence,
	#category : #'Glorp-Database'
}

{ #category : #sequencing }
DB2IdentitySequence >> getSequenceValueFromDatabaseFor: aDatabaseField in: aDatabaseRow using: anAccessor [
	"I do nothing, but I am here for subclassResponsibility reasons"
]

{ #category : #testing }
DB2IdentitySequence >> isIdentityColumn [

	^ true
]

{ #category : #sequencing }
DB2IdentitySequence >> postWriteAssignSequenceValueFor: aDatabaseField in: aDatabaseRow using: anAccessor [

	aDatabaseRow at: aDatabaseField
		put: (((anAccessor
				executeSQLString: 'VALUES IDENTITY_VAL_LOCAL()') first atIndex: 1) asInteger)
]

{ #category : #sequencing }
DB2IdentitySequence >> reserveSequenceNumbers: anInteger in: aSession for: aTable [
	"No real sequences here, just identity columns, which we can't pre-allocate"
]
