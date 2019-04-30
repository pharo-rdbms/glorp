"
DB2IdentityType represents identity column types in DB2. Glorp prefers sequences over identity columns, and uses sequences when generating schemas. But since pre-exisitng DB2 tables may contain identity columns, this class is necessary. See also, DB2Sequence and DB2IdentitySequence.

"
Class {
	#name : #DB2IdentityType,
	#superclass : #GlorpSerialType,
	#category : 'Glorp-Types'
}

{ #category : #initialize }
DB2IdentityType >> initializeForField: aDatabaseField in: aDescriptorSystem [

	sequence isNil ifFalse: [^self].
	sequence := aDescriptorSystem
				databaseIdentitySequenceNamed: (aDescriptorSystem sequenceNameForField: aDatabaseField).
	sequence schema: aDatabaseField table schema
]

{ #category : #testing }
DB2IdentityType >> isIdentityColumn [
	^true
]
