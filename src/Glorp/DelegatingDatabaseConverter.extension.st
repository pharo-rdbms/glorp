Extension { #name : #DelegatingDatabaseConverter }

{ #category : #'*Glorp' }
DelegatingDatabaseConverter class >> hostedBy: anObject fromStToDb: stDbSelector fromDbToSt: dbStSelector [

	^super new
		hostedBy: anObject fromStToDb: stDbSelector fromDbToSt: dbStSelector
]

{ #category : #'*Glorp' }
DelegatingDatabaseConverter class >> named: aSymbol hostedBy: anObject fromStToDb: stDbSelector fromDbToSt: dbStSelector [
	^super new
		named: aSymbol
		hostedBy: anObject
		fromStToDb: stDbSelector
		fromDbToSt: dbStSelector.
]
