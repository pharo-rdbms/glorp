converting
convert: anObject toDatabaseRepresentationAs: aDatabaseType 
	^host perform: stToDbSelector with: anObject with: aDatabaseType.