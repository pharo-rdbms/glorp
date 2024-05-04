Extension { #name : 'PrimaryKeyConstraint' }

{ #category : '*Glorp' }
PrimaryKeyConstraint class >> forTable: aDatabaseTable fields: collDatabaseFields [
	^self new
		forTable: aDatabaseTable  fields: collDatabaseFields;
		yourself
]
