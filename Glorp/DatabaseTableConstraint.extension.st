Extension { #name : #DatabaseTableConstraint }

{ #category : #'*Glorp' }
DatabaseTableConstraint classSide >> forTable: aDatabaseTable [
	^self new
		forTable: aDatabaseTable;
		yourself
]

{ #category : #'*Glorp' }
DatabaseTableConstraint classSide >> new [
	^super new initialize.
]
