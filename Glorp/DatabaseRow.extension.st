Extension { #name : #DatabaseRow }

{ #category : #'*Glorp' }
DatabaseRow classSide >> emptySlot [
	emptySlot == nil ifTrue: [emptySlot := Object new].
	^emptySlot.
]

{ #category : #'*Glorp' }
DatabaseRow classSide >> missingFieldIndicator [
	missingFieldIndicator == nil ifTrue: [missingFieldIndicator := Object new].
	^missingFieldIndicator.
]

{ #category : #'*Glorp' }
DatabaseRow classSide >> new [

	^super new initialize.
]

{ #category : #'*Glorp' }
DatabaseRow classSide >> newForTable: aTable [

	^self new table: aTable.
]

{ #category : #'*Glorp' }
DatabaseRow classSide >> newForTable: aTable withOwner: anObject [

	^self new table: aTable; owner: anObject.
]
