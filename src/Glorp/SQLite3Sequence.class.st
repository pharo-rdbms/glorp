"
Sequences for SQLite.
"
Class {
	#name : #SQLite3Sequence,
	#superclass : #DatabaseSequence,
	#category : #'Glorp-Database'
}

{ #category : #sequencing }
SQLite3Sequence >> getSequenceValueFromDatabaseFor: aField in: aRow using: aSession [
]

{ #category : #testing }
SQLite3Sequence >> isIdentityColumn [

	^ true
]

{ #category : #sequencing }
SQLite3Sequence >> name: aString [
	"We ignore names"
]

{ #category : #sequencing }
SQLite3Sequence >> postWriteAssignSequenceValueFor: aDatabaseField in: aDatabaseRow using: anAccessor [

	| value |
	value := (anAccessor executeSQLString: 'SELECT last_insert_rowid()') first at: 1.
	aDatabaseRow at: aDatabaseField put: value
]

{ #category : #sequencing }
SQLite3Sequence >> reserveSequenceNumbers: anInteger in: aSession for: aTable [
	"No real sequences here, just identity columns, which we can't pre-allocate"
]

{ #category : #sequencing }
SQLite3Sequence >> schema: aString [
	"This is SQLite - we don't have schemas"
]
