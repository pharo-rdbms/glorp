Extension { #name : #DelegatingDatabaseConverter }

{ #category : #'*Glorp' }
DelegatingDatabaseConverter classSide >> hostedBy: anObject fromStToDb: stDbSelector fromDbToSt: dbStSelector [

	^super new
		hostedBy: anObject fromStToDb: stDbSelector fromDbToSt: dbStSelector
]

{ #category : #'*Glorp' }
DelegatingDatabaseConverter classSide >> named: aSymbol hostedBy: anObject fromStToDb: stDbSelector fromDbToSt: dbStSelector [
	^super new
		named: aSymbol
		hostedBy: anObject
		fromStToDb: stDbSelector
		fromDbToSt: dbStSelector.
]
