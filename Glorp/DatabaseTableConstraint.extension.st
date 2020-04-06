Extension { #name : #DatabaseTableConstraint }

{ #category : #'*Glorp' }
DatabaseTableConstraint class >> forTable: aDatabaseTable [
	^self new
		forTable: aDatabaseTable;
		yourself
]

{ #category : #'*Glorp' }
DatabaseTableConstraint class >> new [
	^super new initialize.
]
