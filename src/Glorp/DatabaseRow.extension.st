Extension { #name : #DatabaseRow }

{ #category : #'*Glorp' }
DatabaseRow class >> emptySlot [
	emptySlot == nil ifTrue: [emptySlot := Object new].
	^emptySlot.
]

{ #category : #'*Glorp' }
DatabaseRow class >> missingFieldIndicator [
	missingFieldIndicator == nil ifTrue: [missingFieldIndicator := Object new].
	^missingFieldIndicator.
]

{ #category : #'*Glorp' }
DatabaseRow class >> newForTable: aTable [

	^self new table: aTable.
]

{ #category : #'*Glorp' }
DatabaseRow class >> newForTable: aTable withOwner: anObject [

	^self new table: aTable; owner: anObject.
]
