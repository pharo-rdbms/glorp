Class {
	#name : #GlorpDatabaseSequenceTest,
	#superclass : #GlorpSessionBasedTest,
	#instVars : [
		'sequence',
		'table',
		'row2',
		'row1'
	],
	#category : #'Glorp-Integration-Tests-Database'
}

{ #category : #tests }
GlorpDatabaseSequenceTest >> assignSequences [
	| accessor |
	accessor := session isNil ifFalse: [session accessor].
	row1 preWriteAssignSequencesUsing: session.
	row1 postWriteAssignSequencesUsing: accessor.
	row2 preWriteAssignSequencesUsing: session.
	row2 postWriteAssignSequencesUsing: accessor
]

{ #category : #tests }
GlorpDatabaseSequenceTest >> increment [
	"If the platform>>supportsSettingSequenceIncrement, then this test should ask for the increment from the sequence object itself.  Otherwise, it is the default, 1."

	^system platform supportsSettingSequenceIncrement
		ifTrue: [sequence sequenceIncrement]
		ifFalse: [1]
]

{ #category : #tests }
GlorpDatabaseSequenceTest >> row1Value [
	^row1 atFieldNamed: 'ID'.
]

{ #category : #tests }
GlorpDatabaseSequenceTest >> row2Value [
	^row2 atFieldNamed: 'ID'.
]

{ #category : #setup }
GlorpDatabaseSequenceTest >> setUp [
	super setUp.
	table := session system tableNamed: 'BANK_TRANS'.
	sequence := (table fieldNamed: 'ID') type sequence.
	row1 := DatabaseRow newForTable: table.
	row2 := DatabaseRow newForTable: table.
]

{ #category : #tests }
GlorpDatabaseSequenceTest >> testGetNextValue [
	session platform usesIdentityColumns ifTrue: [^self].
	self assignSequences.
	self assert: self row2Value = (self row1Value + 1).
]

{ #category : #tests }
GlorpDatabaseSequenceTest >> testGetNextValues [
	"If the platform supportsSettingSequenceIncrement then the increment will be computed in the image within each range and only got from the database at the start of each range (i.e. at 1, 4, 7 and 10, since this test's increment is 3 at time of writing - see tableForBANK_TRANS:) in method nextSequenceNumber:."

	| rows thisID nextID |
	session platform usesIdentityColumns ifTrue: [^self].
	rows := Array new: 10.
	1 to: 10 do:
		[:i || row |
		row := DatabaseRow newForTable: table.
		row preWriteAssignSequencesUsing: session.
		row postWriteAssignSequencesUsing: session accessor.
		rows at: i put: row].
	1 to: 9 do:
		[:i |
		thisID := (rows at: i) atFieldNamed: 'ID'.
		nextID := (rows at: i + 1) atFieldNamed: 'ID'.
		self assert: nextID = (thisID + 1)].
]

{ #category : #tests }
GlorpDatabaseSequenceTest >> testReserveEmpty [
	session platform usesIdentityColumns ifTrue: [^self].
	sequence reserveSequenceNumbers: 2 in: session for: table.
	session := nil.
	self assignSequences.
	self assert: self row1Value + self increment = self row2Value.
]

{ #category : #tests }
GlorpDatabaseSequenceTest >> testReserveUsingTable [
	session platform usesIdentityColumns ifTrue: [^self].
	[session beginTransaction.
	self writeTransactionRow: 65.
	self writeTransactionRow: 66.
	self writeTransactionRow: 67.
	sequence reserveSequenceNumbers: 7 in: session for: table]
		ensure: [session rollbackTransaction].
	session := nil.
	self assignSequences.
	self assert: self row1Value + self increment = self row2Value.
]

{ #category : #tests }
GlorpDatabaseSequenceTest >> testReservedNumberAllocation [
	session := nil.
	sequence reservedNumbers add: 23; add: 24.
	self assignSequences.
	self assert: self row1Value = 23.
	self assert: self row2Value = 24.
]

{ #category : #tests }
GlorpDatabaseSequenceTest >> writeTransactionRow: anInteger [
	| tempRow |
	tempRow := DatabaseRow newForTable: table.
	session platform usesIdentityColumns ifFalse: [
		tempRow atFieldNamed: 'ID' put: anInteger].
	tempRow atFieldNamed: 'AMT_CURR' put: 'CDN'.
	session writeRow: tempRow.
]
