"
This is a sequence type for MySQL AutoIncrement fields.
"
Class {
	#name : 'MySQLSequence',
	#superclass : 'NamedSequence',
	#category : 'Glorp-Database',
	#package : 'Glorp',
	#tag : 'Database'
}

{ #category : 'sequencing' }
MySQLSequence >> getSequenceValueFromDatabaseFor: aField in: aRow using: aSession [
]

{ #category : 'testing' }
MySQLSequence >> isIdentityColumn [

	^ true
]

{ #category : 'sequencing' }
MySQLSequence >> postWriteAssignSequenceValueFor: aDatabaseField in: aDatabaseRow using: anAccessor [

	aDatabaseRow at: aDatabaseField
		put: ((anAccessor
				executeSQLString: 'SELECT LAST_INSERT_ID()') first at: 1)
]

{ #category : 'sequencing' }
MySQLSequence >> reserveSequenceNumbers: anInteger in: aSession for: aTable [
	"No real sequences here, just identity columns, which we can't pre-allocate"
]
