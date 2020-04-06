Class {
	#name : #GlorpCursoredCollectionDBTest,
	#superclass : #GlorpSessionBasedTest,
	#category : 'Glorp-Tests-Database'
}

{ #category : #support }
GlorpCursoredCollectionDBTest >> setUp [
	session := GlorpSessionResource current newSession.
	session beginTransaction.
	self writePersonRows.
]

{ #category : #support }
GlorpCursoredCollectionDBTest >> tearDown [
	session rollbackTransaction.
	super tearDown.
]

{ #category : #tests }
GlorpCursoredCollectionDBTest >> testParallelStreams [
	| query person query2 stream1 stream2 address person2 address2 |
	session platform supportsMultipleOpenCursors ifFalse: [^self].
	query := Query read: GlorpPerson.
	query orderBy: [:each | each id].
	query collectionType: GlorpCursoredStream.
	query2 := Query read: GlorpAddress.
	query2 orderBy: [:each | each id].
	query2 collectionType: GlorpCursoredStream.
	stream1 := session execute: query.
	self assert: session privateGetCache numberOfElements = 0.
	stream2 := session execute: query2.
	person := stream1 next.
	self assert: session privateGetCache numberOfElements = 1.
	self assert: person id = 86.
	address := stream2 next.
	self assert: address id = 1.
	self assert: address street = 'Alpha'.
	self assert: session privateGetCache numberOfElements = 2.
	person2 := stream1 next.
	address2 := stream2 next.
	self assert: person2 class == GlorpPerson.
	self assert: address2 class == GlorpAddress.
	self assert: address2 street = 'Beta'.

"SQLite allows multiple processes to have the database file open at once, and multiple processes can read the database at once.  Thus we let that platform return true to #supportsMultipleOpenCursors.  When a process wants to write, it must lock the entire database file for the duration of its update (normally a few milliseconds, during which other processes wait on the writer to finish, then continue).  However this database locking is therefore dependent on the OS file-system and can show issues.  This test, after passing all its assertions, has been seen to fail in tearDown's rollback of the transaction due to 'database is locked'.  The presumption is that both cursors rollback and so appear like competing writes even though neither is really.   Releasing the cursors ends contention and lets the rollback succeed."
	((session platform class == SQLite3Platform) or: [ session platform class == UDBCSQLite3Platform ]) 
	ifTrue:
		[stream1 release. stream1 := nil.
		stream2 release. stream2 := nil].
]

{ #category : #tests }
GlorpCursoredCollectionDBTest >> testReadAsStream [
	| query stream person restOfPeople |
	query := Query read: GlorpPerson.
	query orderBy: [:each | each id].
	query collectionType: GlorpCursoredStream.
	stream := session execute: query.
	self assert: session privateGetCache numberOfElements = 0.
	person := stream next.
	self assert: session privateGetCache numberOfElements = 1.
	self assert: person id = 86.
	restOfPeople := stream upToEnd.
	self assert: restOfPeople size = 2.
	self assert: session privateGetCache numberOfElements = 3.
]

{ #category : #tests }
GlorpCursoredCollectionDBTest >> testReadEmptyStream [
	| query stream person |
	query := Query read: GlorpPerson where: [:each | each id = 999].
	query collectionType: GlorpCursoredStream.
	stream := session execute: query.
	self assert: session privateGetCache numberOfElements = 0.
	person := stream next.
	self assert: session privateGetCache numberOfElements = 0.
	self assert: person isNil.
	self assert: stream atEnd.
]

{ #category : #tests }
GlorpCursoredCollectionDBTest >> testReadLiteralEmptyStream [
	| query stream person |
	query := Query read: GlorpPerson where: false.
	query collectionType: GlorpCursoredStream.
	stream := session execute: query.
	self assert: session privateGetCache numberOfElements = 0.
	person := stream next.
	self assert: session privateGetCache numberOfElements = 0.
	self assert: person isNil.
	self assert: stream atEnd.
]

{ #category : #support }
GlorpCursoredCollectionDBTest >> writePersonRows [
	session writeRow: session system exampleAddressRowForOrdering1.
	session writeRow: session system exampleAddressRowForOrdering2.
	session writeRow: session system exampleAddressRowForOrdering3.
	session writeRow: session system examplePersonRowForOrdering1.
	session writeRow: session system examplePersonRowForOrdering2.
	session writeRow: session system examplePersonRowForOrdering3.
]
