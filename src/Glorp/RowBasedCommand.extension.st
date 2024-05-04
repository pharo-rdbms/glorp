Extension { #name : 'RowBasedCommand' }

{ #category : '*Glorp' }
RowBasedCommand class >> forRow: aDatabaseRow useBinding: aBoolean session: aSession [

	^ self new
		  row: aDatabaseRow;
		  useBinding: aBoolean;
		  session: aSession;
		  yourself
]

{ #category : '*Glorp' }
RowBasedCommand class >> forRows: aCollectionOfDatabaseRows useBinding: aBoolean session: aSession [

	^ self new
		  allRows: aCollectionOfDatabaseRows;
		  row: aCollectionOfDatabaseRows first;
		  useBinding: aBoolean;
		  session: aSession;
		  yourself
]
