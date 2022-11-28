"
This is an abstract superclass for identifier generation mechanisms in the database. For example, Oracle sequences, SQL Server identity columns, and so on.

Subclasses must implement the following messages:
	sequencing
		getSequenceValueFromDatabaseFor:in:using:
		postWriteAssignSequenceValueFor:in:using:

Instance Variables:
	reservedNumbers	<OrderedCollection>	Numbers that we have already reserved and have available. This is only useful if the sequence can generate more than one identifier in a single request, and we have configured it (and ourselves) to do so and use those numbers. This is useful for efficiency when inserting lots of data.


"
Class {
	#name : #DatabaseSequence,
	#superclass : #GlorpDatabaseValueGenerator,
	#instVars : [
		'reservedNumbers'
	],
	#category : 'Glorp-Database'
}

{ #category : #'*Glorp' }
DatabaseSequence class >> named: aString [
	^self new name: aString.
]

{ #category : #'*Glorp' }
DatabaseSequence class >> new [

	^super new initialize.
]

{ #category : #sequencing }
DatabaseSequence >> creationString [

	^'Create sequence ', self qualifiedName.
]

{ #category : #sequencing }
DatabaseSequence >> dropString [

	^'Drop string unspecified for this type of sequence'.
]

{ #category : #sequencing }
DatabaseSequence >> getSequenceValueFromDatabaseFor: aField in: aRow using: aSession [ 
	self subclassResponsibility.
]

{ #category : #sequencing }
DatabaseSequence >> hasReservedNumbers [
	^reservedNumbers notNil and: [reservedNumbers isEmpty not].
]

{ #category : #'initialize/release' }
DatabaseSequence >> initialize [
]

{ #category : #testing }
DatabaseSequence >> isIdentityColumn [
	^false.
]

{ #category : #sequencing }
DatabaseSequence >> nextReservedNumber [
	^reservedNumbers removeFirst.
]

{ #category : #sequencing }
DatabaseSequence >> postWriteAssignSequenceValueFor: aField in: aRow using: anAccessor [
	self subclassResponsibility.
]

{ #category : #sequencing }
DatabaseSequence >> preWriteAssignSequenceValueFor: aField in: aRow using: anAccessor [
	self hasReservedNumbers
		ifTrue: [aRow at: aField put: self nextReservedNumber]
		ifFalse:
			[self
				getSequenceValueFromDatabaseFor: aField
				in: aRow
				using: anAccessor].
]

{ #category : #accessing }
DatabaseSequence >> reservedNumbers [
	reservedNumbers isNil ifTrue: [reservedNumbers := OrderedCollection new: 50].
	^reservedNumbers.
]
