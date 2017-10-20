converting
convert: anObject fromDatabaseRepresentationAs: aDatabaseType 
	^host perform: dbToStSelector with: anObject with: aDatabaseType