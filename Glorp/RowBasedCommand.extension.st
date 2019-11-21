Extension { #name : #RowBasedCommand }

{ #category : #'*Glorp' }
RowBasedCommand classSide >> forRow: aDatabaseRow useBinding: aBoolean session: aSession [
	^(self new)
		row: aDatabaseRow;
		useBinding: aBoolean;
		session: aSession;
		yourself.
]

{ #category : #'*Glorp' }
RowBasedCommand classSide >> forRows: aCollectionOfDatabaseRows useBinding: aBoolean session: aSession [
	^(self new)
		allRows: aCollectionOfDatabaseRows;
		row: aCollectionOfDatabaseRows first;
		useBinding: aBoolean;
		session: aSession;
		yourself.
]
