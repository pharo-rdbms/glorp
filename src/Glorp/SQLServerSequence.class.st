"
This implements SQL Server sequences, which aren't really sequences at all, but identity columns. That means we can't do more than one at a time, and we have to do an extra select to get the value back.
"
Class {
	#name : 'SQLServerSequence',
	#superclass : 'NamedSequence',
	#category : 'Glorp-Database',
	#package : 'Glorp',
	#tag : 'Database'
}

{ #category : 'sequencing' }
SQLServerSequence >> getSequenceValueFromDatabaseFor: aField in: aRow using: aSession [
]

{ #category : 'testing' }
SQLServerSequence >> isIdentityColumn [

	^ true
]

{ #category : 'sequencing' }
SQLServerSequence >> postWriteAssignSequenceValueFor: aDatabaseField in: aDatabaseRow using: anAccessor [

	aDatabaseRow
		at: aDatabaseField
		put: ((anAccessor executeSQLString: 'SELECT @@IDENTITY') first at: 1)
]

{ #category : 'sequencing' }
SQLServerSequence >> reserveSequenceNumbers: anInteger in: aSession for: aTable [
	"No real sequences here, just identity columns, which we can't pre-allocate"
]
