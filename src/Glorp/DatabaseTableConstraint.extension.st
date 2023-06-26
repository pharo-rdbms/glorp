Extension { #name : #DatabaseTableConstraint }

{ #category : #'*Glorp' }
DatabaseTableConstraint class >> forTable: aDatabaseTable [

	^ self new
		  forTable: aDatabaseTable;
		  yourself
]
