Extension { #name : #PrimaryKeyConstraint }

{ #category : #'*Glorp' }
PrimaryKeyConstraint classSide >> forTable: aDatabaseTable fields: collDatabaseFields [
	^self new
		forTable: aDatabaseTable  fields: collDatabaseFields;
		yourself
]
